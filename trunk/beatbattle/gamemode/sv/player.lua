
function GM:PlayerNoClip(ply, on)
	return ply:IsAdmin()
end

function GM:CanPlayerSuicide(ply)
	return false
end


function GM:PlayerCanPickupWeapon(ply, ent)
	return true
end


util.AddNetworkString( "InfoPlayer_Min" )
util.AddNetworkString( "ShowWinner" )

function GM:PlayerInitialSpawn(ply)

SendFragWinning() // Update Him

if Data.RoundStarted then

ply.Inicial = true
timer.Simple(0.5,function() 
ply:Kill()
ply:SetFrags(0)
end) // killing is being lazy.

elseif Data.RoundStarted == false then
SpawnPlayerLocation(ply) // spawn him.
end

end


local MaxFrags = 0
local WinningPlayer = ""
util.AddNetworkString( "WinningPlayer" )
util.AddNetworkString( "Recieve_Damage" )

function SendFragWinning()

for k,v in pairs( player.GetAll() ) do  

	if v:Frags() > MaxFrags then 
		MaxFrags = v:Frags()
		WinningPlayer = v:Name()
	end
	
end

if MaxFrags != 0 then

net.Start( "WinningPlayer" )
net.WriteString(WinningPlayer)
net.WriteString(tostring(MaxFrags))
net.Broadcast()

end

end



function GM:PlayerSwitchFlashlight(ply)
	return ply:Alive()
end


function GM:DoPlayerDeath( ply, attacker, dmginfo )

if ply:IsPlayer() then

if attacker:IsPlayer() then
	attacker:AddFrags(1)
else

if ply.LastAttacker != NULL and CurTime() <= ply.LastAttack then
	ply.LastAttacker:AddFrags(1)
end

end
 
SendFragWinning()

end
 
end

function Spectate(ply)
ply:Spectate(OBS_MODE_ROAMING)
end


function GM:PlayerDeathThink(ply)

	Spectate(ply)
	
     if (CurTime() >= ply.nextspawn and ply.Inicial == false) then
          ply:Spawn()
     end
	 
	 return true
	 
end



function GM:PlayerSpawn(ply)
	SpawnPlayerLocation(ply)
end


function GM:EntityTakeDamage( ent, inflictor, attacker, amount )
 
	if ent:IsPlayer() and attacker:IsPlayer() then
		ent.LastAttacker = attacker
		ent.LastAttack = CurTime() + Data.MinTimeLast
		
		net.Start( "Recieve_Damage" )
		net.WriteString(tostring(amount))
		net.Send(ent)
		
	end
 
end

function SpawnPlayerLocation(ply)

local cl_playermodel = ply:GetInfo("cl_playermodel")
local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
util.PrecacheModel(modelname)
ply:StripWeapons()
ply:SetModel(modelname)
ply:UnSpectate()
ply:SetTeam(TEAM_HUMAN)
ply.LastAttacker = NULL
ply:Give("weapon_MusicGun")

ply:GodEnable()
ply:SetColor(Color(255,1,1,100))
	
if Data.Preparing then
ply:Freeze(true)
ply.Inicial = false
end
	
timer.Simple( Data.GodModeTime , function() 
ply:GodDisable()
ply:SetColor(Color(255,255,255,255))
end)

end


function GM:PlayerDeath( ply, wep, killer )
ply.nextspawn = CurTime() + Data.DeathWaitingTime
end


local Dead = {}
Dead[1] = "vo/npc/male01/pain07.wav"
Dead[2] = "vo/npc/male01/pain08.wav"
Dead[3] = "vo/npc/male01/pain09.wav"
Dead[4] = "vo/npc/male01/no02.wav"
Dead[5] = "vo/npc/male01/help01.wav"
		
function GM:PlayerDeathSound(ply)
ply:EmitSound(Dead[math.Round(math.random(1,table.Count(Dead)))])
end



