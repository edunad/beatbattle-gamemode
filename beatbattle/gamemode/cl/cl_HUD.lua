// BASIC HUD FUNCTIONS

Hud = { }
 
function clr( color ) return color.r, color.g, color.b, color.a; end
 
function Hud:PaintBar( x, y, w, h, colors, value )
 
	self:PaintPanel( x, y, w, h, colors );
 
	x = x + 1; y = y + 1;
	w = w - 2; h = h - 2;
 
	local width = w * math.Clamp( value, 0, 1 );
	local shade = 4;
 
	surface.SetDrawColor( clr( colors.shade ) );
	surface.DrawRect( x, y, width, shade );
 
	surface.SetDrawColor( clr( colors.fill ) );
	surface.DrawRect( x, y + shade, width, h - shade );
 
end
 
function Hud:PaintPanel( x, y, w, h, colors )
 
	surface.SetDrawColor( clr( colors.border ) );
	surface.DrawOutlinedRect( x, y, w, h );
 
	x = x + 1; y = y + 1;
	w = w - 2; h = h - 2;
 
	surface.SetDrawColor( clr( colors.background ) );
	surface.DrawRect( x, y, w, h );
 
end
 
function Hud:PaintText( x, y, text, font, colors )
 
	surface.SetFont( font );
 
	surface.SetTextPos( x + 1, y + 1 );
	surface.SetTextColor( clr( colors.shadow ) );
	surface.DrawText( text );
 
	surface.SetTextPos( x, y );
	surface.SetTextColor( clr( colors.text ) );
	surface.DrawText( text );
 
end

function Hud:TextSize( text, font )
 
	surface.SetFont( font );
	return surface.GetTextSize( text );
 
end


// THE HUD IT SELF

ColorT =
{
 
	shadow = Color( 1, 1, 1, 200 ),
	text = Color( 255, 255, 255, 200 )
 
};



// Nice Effects on Name.
function GM:HUDDrawTargetID()

	local trace = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	
	if ( ValidEntity(trace.Entity) ) then
		if ( trace.Entity:IsPlayer() ) then
			
			local Xs = ScrW() / 2
			local Ys = ScrH() / 2


			draw.SimpleTextOutlined(trace.Entity:Name() ,"Default", Xs, Ys + 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 200))
			
			local HPs = trace.Entity:Health()
						
			if(HPs > 0)then
			
			if HPs >= 80 then
			draw.SimpleTextOutlined(tostring(trace.Entity:Health()) .. "%" ,"Default", Xs, Ys + 25, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 200))
			elseif HPs >= 60 and HPs < 80 then
			draw.SimpleTextOutlined(tostring(trace.Entity:Health()) .. "%" ,"Default", Xs, Ys + 25, Color(255, 200, 0, 255), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 200))
			elseif HPs >= 30 and HPs < 60 then
			draw.SimpleTextOutlined(tostring(trace.Entity:Health()) .. "%" ,"Default", Xs, Ys + 25, Color(255, 80, 0, 255), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 200))
			elseif HPs < 30 then
			draw.SimpleTextOutlined(tostring(trace.Entity:Health()) .. "%" ,"Default", Xs, Ys + 25, Color(255, 30, 0, 255), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 200))
			end
			
			end
			
		end
	end
	
end


	
	
	
local Font = {}
Font.size = ScreenScale(12)
Font.font = "Verdana"
Font.weight = 400

surface.CreateFont( "DesFont", Font)

local Font3 = {}
Font3.size = ScreenScale(72)
Font3.font = "TabLarge"
Font3.weight = 400

surface.CreateFont( "WinnerR", Font)

local Font2 = {}
Font2.size = ScreenScale(24)
Font2.font = "TabLarge"
Font2.weight = 400

surface.CreateFont( "WinFont", Font2)


function GM:HUDPaint( )

	self.BaseClass:HUDPaint()
	
	client = LocalPlayer( )
	
	if client:Alive( ) then

	local HPs = client:Health()	
	
	local Life = surface.GetTextureID("beatbattle_cake/hp_new")
	
	if HPs >= 80 then
	surface.SetDrawColor( 0, 255, 0, 255 )
	elseif HPs >= 60 and HPs < 80 then
	surface.SetDrawColor(255, 200, 0, 255)
	elseif HPs >= 30 and HPs < 60 then
	surface.SetDrawColor( 255, 80, 0, 255)
	elseif HPs < 30 then
	surface.SetDrawColor( 255, 30, 0, 255 )
	end
		
	surface.SetTexture( Life )
	surface.DrawTexturedRect( 12, 12, 128, 128 )
	
	if client:Health() >= 100 then
	Hud:PaintText(37,47,tostring(client:Health()),"WinFont",ColorT)
	elseif client:Health() < 100 and client:Health() >= 10 then
	Hud:PaintText(50,47,tostring(client:Health()),"WinFont",ColorT)
	elseif client:Health() < 10 && client:Health() > 0 then
	Hud:PaintText(60,47,tostring(client:Health()),"WinFont",ColorT)
	end
	
	end	
	
	if WinnerS then
	
	if WinName != "" then
	
	local Win = surface.GetTextureID("beatbattle_cake/cake_winning")
	surface.SetTexture( Win )
	
	draw.DrawText( "Player ".. WinName .. " won the BeatBattle!", "WinFont", ScrW() / 2, 300, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )	
	surface.SetDrawColor( 255, 255, 255, 255 )
	else
	
	local Win = surface.GetTextureID("beatbattle_cake/cake_none")
	surface.SetTexture( Win )
	
	draw.DrawText( "Nobody won the BeatBattle!", "WinFont", ScrW() / 2, 300, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	surface.SetDrawColor( 255, 255, 255, 255 )
	end
	
	surface.DrawTexturedRect( ScrW() / 2 - 80, 150, 128, 128 )
	
	end
	 
	if CANTPLAY then
		draw.DrawText( "Not Enough Players to Start!", "WinFont", ScrW() / 2, 200, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )	
		draw.DrawText( "Min Players : " .. MinPly, "WinFont", ScrW() / 2, 270, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )	
	end
	
	
end



function DrawName( ply )
 
	if WinName != "" then
 
	if ply:Name() == WinName and ply:Alive() then
	
	local offset = Vector( 0, 0, 100 )
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
	
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
 
	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
	
	draw.DrawText( "Current Winner", "DesFont", 2, 52, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	draw.DrawText( "Total Kills : " .. WinScore, "DesFont", 2, 72, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		
	draw.TexturedQuad
	{
	texture = surface.GetTextureID("beatbattle_cake/cake_winning"),
	x = -30,
	y = -30,
	w = 74,
	h = 74
	}

	cam.End3D2D()
	
	end
	
	end
	
	
end
hook.Add( "PostPlayerDraw", "DrawWinner", DrawName )





// Nice RP Effect :)



net.Receive( "Recieve_Damage", function(len, ply) 
EPICRP(tonumber(net.ReadString()))
end)


Tabls = {}
function EPICRP(damage)
local tbl = {}
tbl.Y = 110
tbl.Dmg = damage
tbl.Alpha = 255
tbl.Time = 0
tbl.Speed = math.random(1,3)
table.insert(Tabls, tbl)
end


hook.Add("HUDPaint", "hahaharp", function()

for k, v in pairs(Tabls) do
v.Time = v.Time + 0.01
draw.SimpleText("-" .. tostring(v.Dmg), "DesFont",v.Y, math.cos(v.Time*v.Speed)*25 + 55, Color(255, 0, 0, v.Alpha))
end

end)


hook.Add("Think","RPTHINK",function()
for i = 1, #Tabls do

if (Tabls[i]) then
Tabls[i].Alpha = Tabls[i].Alpha - 1
Tabls[i].Y = Tabls[i].Y + 1	

if (Tabls[i].Alpha < 0) then
Tabls[i].Y = 0
table.remove(Tabls, i)
i = i - 1
end
end
end
end)
