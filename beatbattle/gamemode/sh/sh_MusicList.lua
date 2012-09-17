MUSICLIST = {}

function AddMusic(name,musicpath,datapath)
	print("=== Added Music : ".. name .. " ===")
	MUSICLIST[#MUSICLIST+ 1] = {name = name,musicpath=musicpath,datapath=datapath} 
end



AddMusic(
	"Avast My Ass", -- The Music Name
    "avast_my_ass.mp3", -- Music Name Path
	"avast_my_ass" -- C# Xna Beat File Name
)

AddMusic(
	"CaveStory Theme", -- The Music Name
    "cave_story.mp3", -- Music Name Path
	"cave_story" -- C# Xna Beat File Name
)


AddMusic(
	"Pain Game", -- The Music Name
    "pain_game.mp3", -- Music Name Path
	"pain_game" -- C# Xna Beat File Name
)


AddMusic(
	"Rythm Heaven Mix", -- The Music Name
    "rythm_heaven.mp3", -- Music Name Path
	"rythm_heaven" -- C# Xna Beat File Name
)

