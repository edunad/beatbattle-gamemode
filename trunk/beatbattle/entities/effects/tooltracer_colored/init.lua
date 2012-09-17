

//EFFECT.Mat = Material( "effects/tool_tracer" )
EFFECT.Mat = Material( "beatbattle_cake/new_beam" )

--[[---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	-- Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	self.R = 255
	self.B = 255
	self.G = 255
	self.Alpha = 255

	self.Length = (self.StartPos - self.EndPos):Length()
		
end

--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 2048
	
	
	if (self.Alpha < 0) then return false end
	return true

end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end

	render.SetMaterial( self.Mat )
	local texcoord = math.Rand( 0, 1 )
	render.DrawBeam( self.StartPos, 										-- Start
					 self.EndPos,											-- End
					 8,													-- Width
					 texcoord,														-- Start tex coord
					 texcoord + self.Length / 128,									-- End tex coord
					 Color( self.R, self.B, self.G, self.Alpha ) )		-- Color (optional)

end
