include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self:PhysicsInit( SOLID_BSP )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BSP )
	self:SetNoDraw( false )
	self:SetColor(Color(1,1,1,255))
	
	table.insert(Data.OutPlatForm,self)
	
	local min, max = self:WorldSpaceAABB();
	self.Pos = ( min + max ) / 2
	self.Min = min
	self.Max = max
	
local prop = self:GetPhysicsObject()
prop:EnableMotion( false )

end
