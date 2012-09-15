
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then

    SWEP.PrintName            = "BeatGun"
    SWEP.Author                = "FailCake :D"
    SWEP.Slot                = 1
    SWEP.SlotPos            = 1
  
end

SWEP.ViewModel            = "models/weapons/v_pistol.mdl"
SWEP.WorldModel            = "models/weapons/w_pistol.mdl"
SWEP.HoldType            = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.Primary.ClipSize        = 0
SWEP.Primary.DefaultClip    = 0
SWEP.Primary.Automatic        = false
SWEP.Primary.Ammo            = "none"
SWEP.Primary.DamageBase        = 15

SWEP.Secondary.ClipSize        = 0
SWEP.Secondary.DefaultClip    = 0
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none"
SWEP.Secondary.DamageBase    = 5

SWEP.DamageMul = 2

SWEP.Weight                = 5
SWEP.AutoSwitchTo        = false
SWEP.AutoSwitchFrom        = false

SWEP.DrawAmmo            = false
SWEP.DrawCrosshair        = true

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end


function SWEP:FireWeapon()

	local num_bullets = 1
    local damage = 6
    local aimcone = 0
    
    local bullet = {}
    bullet.Num         = num_bullets
	bullet.Src 		= self.Owner:GetShootPos()			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
    bullet.Spread     = Vector( 0, 0, 0 )
    bullet.Tracer    = 1
    bullet.TracerName = "tooltracer_colored"
    bullet.Force    = 1
    bullet.Damage    = damage
    bullet.AmmoType = "Pistol"
	
    self.Owner:FireBullets( bullet )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

end

function SWEP:PrimaryAttack()

end
 


function SWEP:Deploy()
return true
end
 
function SWEP:Holster()
return true
end

