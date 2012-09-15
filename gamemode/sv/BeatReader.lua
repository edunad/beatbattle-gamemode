-- BY BROMVLIEG AND FAILCAKE
-- For BeatBattle Gamemode!

if BEATREADER then
	BEATREADER:Stop()
	BEATREADER = nil
end

util.AddNetworkString( "MusicInfo" )
util.AddNetworkString( "NextMusicS" )
util.AddNetworkString( "RoundInfo" )



function StartMusic()


	for i,v in pairs(Data.OutPlatForm) do
	v:SetColor(Color(255,255,255,255))
	end
	
	for v,k in pairs(player.GetAll()) do
	k:Freeze(false) // Unfreeze Everyone
	end
	
	// Get A RandomMusic
	Rand = GetRandomNumber()
	Data.Preparing = false
	Data.RoundStarted = true
	Data.OldMusic = Rand
	
	local f = file.Open("gamemodes/beatbattle/content/data/BeatBattle/".. MUSICLIST[Rand].datapath ..".txt", "rb", "GAME")
	local data = f:Read(f:Size())
	f:Close()
	
	BEATREADER = BeatReader.New(data)
	BEATREADER:Start()
	
	net.Start( "MusicInfo" ) // Send the music name.
	net.WriteString(MUSICLIST[Rand].name)
	net.Broadcast()
	


end



function StopSpeaker() // MusicEnded

if Data.CanContinue then
CheckRounds()

net.Start( "CanPlay" )
net.Broadcast()

else
timer.Simple(1,StopSpeaker)

net.Start( "CantPlay" )
net.WriteString(Data.MinPlayers)
net.Broadcast()

end

end





function PrepareNextMusic()
Data.RoundStarted = false
Data.Preparing = true

for i,v in pairs(Data.OutPlatForm) do
	v:SetColor(Color(1,1,1,255))
end
	
for v,k in pairs(player.GetAll()) do
	k:Spawn()
	k.Inicial = false
	k:Freeze(true)
end

timer.Simple(Data.NextMusicDelay,StartMusic)
end






function StartSpeaker()

for i,v in pairs(player.GetAll()) do
	v:EmitSound("BeatBattle/" .. MUSICLIST[Rand].musicpath)
end
	
end

function WeaponFire()
	for i,v in pairs(player.GetAll()) do
		if v:Alive() then
			v:GetActiveWeapon():FireWeapon()
		end
	end		
	
	
end


BeatReader = {}

function BeatReader.New(data)
	local obj = BeatReader._baseobj:Create(data)
	
	function obj:OnStart()
		print("Started BeatReader (" .. self._name .. ")")	
		StartSpeaker()
	end
	
	function obj:OnStop()
		print("Stopped BeatReader (" .. self._name .. ")")		
	end
	
	function obj:OnBeatChange(gotbeat, curbeat, curtime, nextbeatchange, offset, len)
		WeaponFire()
	end
	
	function obj:OnBeat(curbeat, curtime)
	
		for i,v in pairs(Data.OutPlatForm) do
		v:SetColor(Color(math.random(1,255),math.random(1,255),math.random(1,255)))
		end	
		
	end
	
	return obj
end

BeatReader._baseobj = {}
	BeatReader._baseobj._started = false
	
	
function BeatReader._baseobj:Create(data)
		local o = {}
		setmetatable(o, { __index = self })
		
		o._data = data
		o._len = #data
		o._name = tostring(math.Rand(0, 1000)) .. tostring(CurTime())
		
		return o
end
	
function BeatReader._baseobj:_readtime()
		local p = self._pos
		local d = self._data
		b4 = string.byte(string.sub(d, p, p))
		b3 = string.byte(string.sub(d, p + 1, p + 1))
		b2 = string.byte(string.sub(d, p + 2, p + 2))
		b1 = string.byte(string.sub(d, p + 3, p + 3))
		
		if b1 == nil then
			self:OnEnd()
			self:Stop()
		end
		
		local n = b1*16777216 + b2*65536 + b3*256 + b4
		n = (n > 2147483647) and (n - 4294967296) or n
		
		self._pos = self._pos + 4
		
		
		
		return n / 1000
end
	
function BeatReader._baseobj:_readbeat()
		self._pos = self._pos + 1
		return string.byte(string.sub(self._data, self._pos - 1, self._pos - 1))
end
	
function BeatReader._baseobj:Stop()
		hook.Remove("Tick", "BeatReader:" .. self._name)
		self:OnStop();
end
	
function BeatReader._baseobj:OnEnd() 
StopSpeaker()
end	
	
function BeatReader._baseobj:Start()
		local obj = self
		
		self._pos = 1
		self._starttime = CurTime()
		self._beattime = CurTime()
		self._nexttrigger = self._starttime + self:_readtime()
		self._gotbeat = false
	
		local function tickhook()
			if (CurTime() >= self._nexttrigger) then
				local newbeat = self:_readbeat() / 100
				local oldtrig = self._nexttrigger
				
				if (self._offset == self._len) then
				self:OnEnd()
				self:Stop()
				end

				local nbt = self:_readtime()
				
				if (self._gotbeat ~= (newbeat ~= 0)) then
					self._beattime = CurTime() + self._beat
				end
				
				self._gotbeat = newbeat ~= 0
				self._nexttrigger = self._starttime + nbt
				self._beat = newbeat
				self:OnBeatChange(self._gotbeat, newbeat, oldtrig - self._starttime, self._nexttrigger - CurTime(), self._pos, self._len)
			end
			
			if (self._gotbeat and CurTime() > self._beattime) then
				self._beattime = CurTime() + self._beat
				self:OnBeat(self._beat, CurTime() - self._starttime)
			end
		end
		
		hook.Add("Tick", "BeatReader:" .. obj._name, tickhook)
		self:OnStart();
end