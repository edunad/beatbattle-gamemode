using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;
using System.IO;
using System.Threading;

namespace BeatBattle_Parser
{
    public class Game1 : Microsoft.Xna.Framework.Game {
        public GraphicsDeviceManager graphics;
        public SpriteBatch spriteBatch;

        public SpriteFont font;
        public Song song;
        public string Status = "Finding stable beat...";
        public byte CurrentAvg;
        public byte OldAvg = 0;

        public Thread RecorderThread;
        public BeatData[] Recorded;
        public int Offset;
        public bool Once;

        public byte LastStable;
        public DateTime StableTime;
        public bool Stable;
        public int StablePoints;

        public float DropSpeed;
        public float CurHeight;

        public DateTime LastTick;
        public Texture2D Pixel;

        public double[] Buffer = new double[1000];

        public struct BeatData {
            public byte Speed;
            public double Time;
        }

        public Game1() {
            this.graphics = new GraphicsDeviceManager(this) { PreferMultiSampling = true };
            this.Content.RootDirectory = "Content";

            this.IsMouseVisible = true;
            this.graphics.PreferredBackBufferWidth = 300;
            this.graphics.PreferredBackBufferHeight = 100;
        }

        protected override void Initialize() {
            base.Initialize();
            MediaPlayer.IsVisualizationEnabled = true;
            MediaPlayer.Play(song);

            this.LastTick = DateTime.Now;

            this.RecorderThread = new Thread(new ThreadStart(this.StartRecording));
            this.RecorderThread.Start();

        }

        protected override void LoadContent() {
            spriteBatch = new SpriteBatch(GraphicsDevice);

            song = Content.Load<Song>("song");
            font = Content.Load<SpriteFont>("font");

            Pixel = new Texture2D(GraphicsDevice, 1, 1);
            Pixel.SetData<Color>(new Color[] { Color.White });
        }

        protected override void Update(GameTime gameTime) {
            if (!this.Stable) {
                if ((DateTime.Now - this.StableTime).TotalSeconds > 1) {
                    this.StableTime = DateTime.Now;

                    if (Math.Abs(this.LastStable - this.CurrentAvg) < 4) {
                        this.StablePoints++;

                        if (this.StablePoints > 3) {
                            this.Stable = true;
                            this.Status = "Recording...";
                        }
                    } else {
                        this.StablePoints = 0;
                    }

                    this.LastStable = this.CurrentAvg;
                }
            }

            base.Update(gameTime);
        }

        protected override void EndRun() {
            try {
                this.RecorderThread.Abort();
            } catch { }
        }

        protected override void Draw(GameTime gameTime) {
            if ((DateTime.Now - this.LastTick).TotalSeconds * 100 > this.CurrentAvg && this.Stable) {
                this.CurHeight = 1;
                this.DropSpeed = 0;
                this.LastTick = DateTime.Now;
            } else {
                this.DropSpeed += 0.002f;

                this.CurHeight -= this.DropSpeed;
                if (this.CurHeight < 0) this.CurHeight = 0;
            }
            
            GraphicsDevice.Clear(Color.Black);
            
            int h = (int)(CurHeight * 100);
            TimeSpan tsa = MediaPlayer.PlayPosition;
            TimeSpan tsb = song.Duration;
            
            string mina = tsa.Minutes.ToString();
            string seca = tsa.Seconds.ToString();
            string mila = Math.Round(tsa.Milliseconds / 100d).ToString();

            string minb = tsb.Minutes.ToString();
            string secb = tsb.Seconds.ToString();
            string milb = Math.Round(tsb.Milliseconds / 100d).ToString();

            if (mina.Length == 1) mina = "0" + mina;
            if (seca.Length == 1) seca = "0" + seca;
            if (mila.Length == 2) mila = "9";

            if (minb.Length == 1) minb = "0" + minb;
            if (secb.Length == 1) secb = "0" + secb;
            if (milb.Length == 2) milb = "9";

            spriteBatch.Begin();
            spriteBatch.DrawString(font, "Beat speed: 0." + this.CurrentAvg, new Vector2(10, 0), Color.White);
            spriteBatch.DrawString(font, "Status: " + this.Status, new Vector2(10, 20), Color.White);
            spriteBatch.DrawString(font, "Beat changes: " + (this.Offset + 1), new Vector2(10, 40), Color.White);
            spriteBatch.DrawString(font, mina + ":" + seca + ":" + mila + "/" + minb + ":" + secb + ":" + milb, new Vector2(10, 80), Color.White);
            spriteBatch.Draw(Pixel, new Rectangle(280, 100 - h, 20, h), new Color(50, 100, 50));

            VisualizationData vdata = new VisualizationData();
            MediaPlayer.GetVisualizationData(vdata);
            int count = vdata.Frequencies.Count;

            spriteBatch.End();

            base.Draw(gameTime);
        }


        public void Line(float x0, float y0, float x1, float y1, float width, Color color) {
            float ang = (float)-Math.Atan2(x0 - x1, y0 - y1) - (float)(Math.PI / 2);
            float dist = (float)Math.Sqrt(((x0 - x1) * (x0 - x1)) + ((y0 - y1) * (y0 - y1)));

            spriteBatch.Draw(Pixel, new Vector2(x0, y0), null, color, ang, new Vector2(0, 0.5f), new Vector2(dist, width), SpriteEffects.None, 0);
        }

        public void StartRecording() {
            this.Recorded = new BeatData[1024];
            this.Offset = -1;

            this.DoRecording();
        }

        public void DoRecording() {
            VisualizationData vdata = new VisualizationData();
            double t = 0;

            while (true) {
                Thread.Sleep(1);

                if (MediaPlayer.State == MediaState.Playing) {
                    MediaPlayer.GetVisualizationData(vdata);
                    t = MediaPlayer.PlayPosition.TotalSeconds;
                } else if (MediaPlayer.State == MediaState.Stopped) {
                    this.StopRecording();
                    break;
                } else {
                    continue;
                }

                int bufflen = this.Buffer.Length - 1;
                for (int i = 0; i < bufflen; i++)
                    this.Buffer[i] = this.Buffer[i + 1];

                this.Buffer[bufflen] = Math.Round(vdata.Frequencies.Take(85).Average(), 2);

                double avg = 0;
                bufflen++;
                for (int i = 0; i < bufflen; i++)
                    avg += this.Buffer[i];

                avg /= bufflen;

                this.CurrentAvg = (byte)(avg * 100);

                if (!this.Stable)
                    continue;

                if (this.CurrentAvg != this.OldAvg) {
                    this.Recorded[++this.Offset] = new BeatData() { Speed = this.CurrentAvg, Time = t };
                    this.OldAvg = this.CurrentAvg;

                    if (this.Recorded.Length == this.Offset + 1) {
                        BeatData[] n = new BeatData[this.Offset + 1024];
                        Array.Copy(this.Recorded, n, this.Offset);
                        this.Recorded = n;
                    }
                }
            }
        }

        public void StopRecording() {
            this.Status = "Saving";

            if (File.Exists("out.txt")) File.Delete("out.txt");

            BinaryWriter bw = new BinaryWriter(File.OpenWrite("out.txt"));

            bw.Write(0);
            bw.Write((byte)0);

            for (int i = 0; i < this.Offset; i++) {
                BeatData bd = this.Recorded[i];

                bw.Write((int)(bd.Time * 1000));
                bw.Write(bd.Speed);
            }

            bw.Flush();
            bw.Close();

            this.Status = "saved " + this.Offset + " beat changes";
        }
    }
}
