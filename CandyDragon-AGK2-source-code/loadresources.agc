
/*
global variables to store reference to all resources such as images, sounds and fonts used globally in the game.
you may want to consider to load resources at the beginning of each level of your game to save memory but since this game has only a single level anyway, I decided to preload everything here now.
*/
global global_gameURL as string = "https://gametemplates.itch.io/"
global global_saveMusicFile as string = "_musicOn"
global global_saveSoundFile as string = "_soundOn"
global global_saveBestScoreFile as string = "_bestscore"
global global_backgroundImg  as integer
global global_dragonImg as integer[3]
global global_candyImg as integer[9]
global global_dragonBubbleImg as integer
global global_buttonImg as integer
global global_font as integer

global global_gulpSnd as integer
global global_burpSnd as integer
global global_gameMusic as integer
global global_menuMusic as integer
global global_endMusic as integer
global global_currentMusic as integer

global global_healthBarImg as integer
global global_healthBarBgImg as integer

global global_musicButtonImg as integer[1]
global global_soundButtonImg as integer[1]

global global_priceTagImg as integer

global saveFile as integer


function loadResources()
	
	//load if the sound and music is toggled on or off
	if GetFileExists(global_saveMusicFile)
		saveFile = OpenToRead(global_saveMusicFile)
		musicOn = ReadInteger(saveFile)
		CloseFile(saveFile)
	endif
	
	If GetFileExists(global_saveSoundFile)
		saveFile = OpenToRead(global_saveSoundFile)
		soundOn = ReadInteger(saveFile)
		CloseFile(saveFile)
	endif
	
	//load background image
	global_backgroundImg = LoadImage("images/background.png")
	
	//load dragon images
	for i = 0 to global_dragonImg.length
		global_dragonImg[i] = LoadImage("images/frame-" + Str(i + 1) + ".png")
	next i
	
	//load the think bubble image of the dragon
	global_dragonBubbleImg = LoadImage("images/thought.png")
	
	//load candy images
	global_candyImg[0] = LoadImage("images/bean_orange.png")
	global_candyImg[1] = LoadImage("images/candycane.png")
	global_candyImg[2] = LoadImage("images/candycorn.png")
	global_candyImg[3] = LoadImage("images/candyhumbug.png")
	global_candyImg[4] = LoadImage("images/heart_red.png")
	global_candyImg[5] = LoadImage("images/jelly_red.png")
	global_candyImg[6] = LoadImage("images/jellybig_green.png")
	global_candyImg[7] = LoadImage("images/lollipop_rainbow.png")
	global_candyImg[8] = LoadImage("images/swirlstroke_purple.png")
	global_candyImg[9] = LoadImage("images/wrappedtrans_orange.png")
	
	//load button image
	global_buttonImg = LoadImage("images/button.png")
	
	//load health bar image
	global_healthBarImg = LoadImage("images/progress_all.png")
	global_healthBarBgImg = LoadImage("images/progress_none.png")
	
	//load music button images
	global_musicButtonImg[0] = LoadImage("images/music_on.png")
	global_musicButtonImg[1] = LoadImage("images/music_off.png")
	
	//load sound button images
	global_soundButtonImg[0] = LoadImage("images/sound_on.png")
	global_soundButtonImg[1] = LoadImage("images/sound_off.png")
	
	//load price tag image
	global_priceTagImg = LoadImage("images/price-tag.png")

	//load dragon sounds
	global_gulpSnd = LoadSoundOGG("sounds/gulp.ogg")
	global_burpSnd = LoadSoundOGG("sounds/burp.ogg")
	
	//load music
	global_menuMusic = LoadMusicOGG("sounds/Caped-Crusader-Cat.ogg")
	global_gameMusic = LoadMusicOGG("sounds/Bozos-Fun-House.ogg")
	global_endMusic = LoadMusicOGG("sounds/Down-the-Drain.ogg")
	
	//load font
	global_font = LoadFont("fonts/Lobster-Regular.ttf")
	
endfunction

//function to cleare the current state from memory and change the state for example when switching from main menu to the game and from the game to the score screen
function global_clearState()
	ClearScreen()
	DeleteAllSprites()
	DeleteAllText()
	if GetMusicExistsOGG(global_currentMusic) then StopMusicOGG(global_currentMusic)
	Sync() //make sure before start loading and running the next state, everything is updated it helps to avoid a problem with the pointer when pressing the buttons
endfunction


//functions to save if the music and sound is toggled on or off
function global_saveMusic()
	//save if the music is toggled on or off
	saveFile = OpenToWrite(global_saveMusicFile)
	WriteInteger(saveFile, musicOn)
	CloseFile(savefile)
endFunction

function global_saveSound()
	//save if the sound is toggled on or off
	saveFile = OpenToWrite(global_saveSoundFile)
	WriteInteger(saveFile, soundOn)
	CloseFile(savefile)
endfunction
