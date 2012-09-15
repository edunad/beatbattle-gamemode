
function GM:Initialize()
CountPlayers() // Count
StopSpeaker() // AutoStart
end


util.AddNetworkString( "CantPlay" )
util.AddNetworkString( "CanPlay" )

function CountPlayers()

if #player.GetAll() >= Data.MinPlayers then
Data.CanContinue = true
else
Data.CanContinue = false
end

end

timer.Create("Count",1,0,CountPlayers)

function GetRandomNumber() // never repeat the same music.

local Num = math.random(1,#MUSICLIST)

while Num == Data.OldMusic do
Num = math.random(1,#MUSICLIST)
end

return Num

end


// ROUND SYSTEM (YEAH!) //

function ReloadMap()
RunConsoleCommand("changelevel", "bb_blockworld")
end


function CheckRounds()

if Data.CurrentRound < Data.MaxRounds then

Data.CurrentRound = Data.CurrentRound + 1

net.Start( "RoundInfo" ) 
net.WriteString(tostring(Data.CurrentRound))
net.WriteString(tostring(Data.MaxRounds))
net.Broadcast()

net.Start( "NextMusicS" ) // Send the music name.
net.WriteString(tostring(Data.NextMusicDelay))
net.Broadcast()

PrepareNextMusic()

else // Ends.

timer.Destroy("Count")
FinishGame()

end

end


function GM:ShowHelp( ply )
    SendUserMessage("ModelMenu", ply)
end

function ChangeModel(ply,cmd,args)
ply:SetModel(tostring(args[1]))
end
concommand.Add("ChangeModels",ChangeModel)

function FinishGame()

for i,v in pairs(player.GetAll()) do
v:Spawn()
v:Freeze(true) // freeze them
v:StripWeapons() // remove all
end

net.Start( "ShowWinner" ) // Show the Winner and the time warning
net.WriteString(tostring(Data.ReloadMapTime))
net.Broadcast()

timer.Simple(Data.ReloadMapTime,ReloadMap)
end
