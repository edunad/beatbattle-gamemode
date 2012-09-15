
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


Data = Data or {}
Data.OutPlatForm = {}	

Data.LastMusic = 0

Data.MinPlayers = 2
Data.DeathWaitingTime = 10	
Data.NextMusicDelay = 10
Data.ReloadMapTime = 25

Data.CurrentRound = 0
Data.MaxRounds = 5
Data.OldMusic = 0

Data.Preparing = false
Data.CanContinue = false
Data.RoundStarted = false
Data.GodModeTime = 3 // seconds
Data.MinTimeLast = 5 // seconds

-- SERVER-SIDE
include("sv/Gamemode.lua")
include("sv/player.lua")
include("sv/BeatReader.lua")
-- END


-- SHARED
include("sh/sh_MusicList.lua")
AddCSLuaFile("sh/sh_MusicList.lua")
-- END


-- CLIENT-SIDE
AddCSLuaFile("cl/cl_HUD.lua")
-- END

-- RESOURCE
resource.AddFile("sound/BeatBattle/pain_game.mp3")
resource.AddFile("sound/BeatBattle/rythm_heaven.mp3")
resource.AddFile("sound/BeatBattle/avast_my_ass.mp3")
resource.AddFile("sound/BeatBattle/cave_story.mp3")

// MATERIALS
resource.AddFile("materials/beatbattle_cake/hp_new.vmt")
resource.AddFile("materials/beatbattle_cake/hp_new.vtf")
resource.AddFile("materials/beatbattle_cake/new_beam.vmt")
resource.AddFile("materials/beatbattle_cake/new_beam.vtf")
resource.AddFile("materials/beatbattle_cake/cake_winning.vmt")
resource.AddFile("materials/beatbattle_cake/cake_winning.vtf")
resource.AddFile("materials/beatbattle_cake/cake_none.vmt")
resource.AddFile("materials/beatbattle_cake/cake_none.vtf")
-- END
