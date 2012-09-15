include("shared.lua")
include( "cl/cl_HUD.lua" )

local hud = {"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo" , "CHudWeaponSelection"}
function GM:HUDShouldDraw(name)

   for k, v in pairs(hud) do
      if name == v then return false end
   end

   return true
end



function GM:HUDAmmoPickedUp( itemname, amount )
return false
end 

language.Add ("trigger_hurt", "Falled Into Deep Space")

// The Winning Thing
WinName = ""
WinScore = ""
net.Receive( "WinningPlayer", function(len, ply) 
WinName = net.ReadString()
WinScore = net.ReadString()
end)


// CHAT THINGS! Mostly Info!
CANTPLAY = false
MinPly = 0

net.Receive( "CantPlay", function(len, ply) 
CANTPLAY = true
MinPly = net.ReadString()
end)

net.Receive( "CanPlay", function(len, ply) 
CANTPLAY = false
end)



net.Receive( "MusicInfo", function(len, ply) 
chat.AddText(Color(1,255,1),"[Info] ",Color(255,255,255),"Now Playing : " .. net.ReadString())
end)

net.Receive( "NextMusicS", function(len, ply) 
chat.AddText(Color(1,255,1),"[Info] ",Color(255,255,255),"Next music in "..net.ReadString() .." Seconds!")
end)

net.Receive( "InfoPlayer", function(len, ply) 
chat.AddText(Color(1,255,1),"[Info] ",Color(255,255,255),"Min Players Reached! Music will start in 10 seconds!")
end)

net.Receive( "InfoPlayer_Min", function(len, ply) 
chat.AddText(Color(255,1,1),"[Warning] ",Color(255,255,255),"Not Enough Players to Start! (Min "..net.ReadString()..")")
end)

net.Receive( "RoundInfo", function(len, ply) 
chat.AddText(Color(1,255,1),"[Info] ",Color(255,255,255),"Current Music Round "..net.ReadString() .. " of " .. net.ReadString())
end)

WinnerS = false
net.Receive( "ShowWinner", function(len, ply) 
WinnerS = true
chat.AddText(Color(255,1,1),"[Warning] ",Color(255,255,255),"Map will Restart in "..net.ReadString().." seconds!")
end)


// Model Menu
function Model_Menu(ply)

local Models = {}

Models[1] = "models/player/Group01/Female_01.mdl"
Models[2] = "models/player/Group01/Female_02.mdl"
Models[3] = "models/player/Group01/Female_03.mdl"
Models[4] = "models/player/Group01/Female_04.mdl"
Models[6] = "models/player/Group01/Female_06.mdl"
Models[7] = "models/player/Group01/Female_07.mdl"

Models[8] = "models/player/Group01/Male_01.mdl"
Models[9] = "models/player/Group01/Male_02.mdl"
Models[10] = "models/player/Group01/Male_03.mdl"
Models[11] = "models/player/Group01/Male_04.mdl"
Models[12] = "models/player/Group01/Male_05.mdl"
Models[13] = "models/player/Group01/Male_06.mdl"
Models[14] = "models/player/Group01/Male_07.mdl"
Models[15] = "models/player/Group01/Male_08.mdl"
Models[16] = "models/player/Group01/Male_09.mdl"

Models[17] = "models/player/Group03/Female_01.mdl"
Models[18] = "models/player/Group03/Female_02.mdl"
Models[19] = "models/player/Group03/Female_03.mdl"
Models[20] = "models/player/Group03/Female_04.mdl"
Models[22] = "models/player/Group03/Female_06.mdl"
Models[23] = "models/player/Group03/Female_07.mdl"

Models[24] = "models/player/Group03/Male_01.mdl"
Models[25] = "models/player/Group03/Male_02.mdl"
Models[26] = "models/player/Group03/Male_03.mdl"
Models[27] = "models/player/Group03/Male_04.mdl"
Models[28] = "models/player/Group03/Male_05.mdl"
Models[29] = "models/player/Group03/Male_06.mdl"
Models[30] = "models/player/Group03/Male_07.mdl"
Models[31] = "models/player/Group03/Male_08.mdl"
Models[32] = "models/player/Group03/Male_09.mdl"

Models[33] = "models/player/Kleiner.mdl"
Models[34] = "models/player/alyx.mdl"
Models[35] = "models/player/barney.mdl"
Models[36] = "models/player/charple01.mdl"
Models[37] = "models/player/breen.mdl"
Models[38] = "models/player/classic.mdl"
Models[39] = "models/player/combine_soldier.mdl"
Models[40] = "models/player/combine_soldier_prisonguard.mdl"
Models[41] = "models/player/combine_super_soldier.mdl"
Models[42] = "models/player/combine_soldier.mdl"
Models[43] = "models/player/combine_soldier_prisonguard.mdl"
Models[44] = "models/player/combine_super_soldier.mdl"

Models[45] = "models/player/odessa.mdl"
Models[46] = "models/player/soldier_stripped.mdl"
Models[47] = "models/player/zombiefast.mdl"

Models[48] = "models/player/gman_high.mdl"
Models[49] = "models/player/police.mdl"
Models[50] = "models/player/monk.mdl"
Models[51] = "models/player/mossman.mdl"
Models[52] = "models/player/zombie_soldier.mdl"

    local frame = vgui.Create("DFrame")
	local IconList = vgui.Create( "DPanelList", frame ) 
 
	
	frame:SetSize(550,550)
	frame:SetTitle("Model Changer")
	frame:MakePopup()
    frame:Center()
	
 	IconList:EnableVerticalScrollbar( false ) 
 	IconList:EnableHorizontal( true ) 
 	IconList:SetPadding( 4 ) 
	IconList:SetPos(10,30)
	IconList:SetSize(520, 500)
	
	local ply = LocalPlayer()
  
	for k,v in pairs(Models) do
	local icon = vgui.Create( "SpawnIcon", IconList ) 
	icon:SetModel( v )
 	IconList:AddItem( icon )
	icon.DoClick = function( icon )
	surface.PlaySound( "ui/buttonclickrelease.wav" )
	RunConsoleCommand("ChangeModels",v)
	end 
	end 	
end
usermessage.Hook( "ModelMenu", Model_Menu )