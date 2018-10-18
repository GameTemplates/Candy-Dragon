

//globals to store reference to all resources used in the main menu state
global mm_buttonSpr as integer
global mm_startGameTxt as integer
global mm_titleTxt as integer
global mm_dragonSpr as integer
global mm_dragonBubbleSpr as integer
global mm_dragonCandySpr as integer
global mm_dragonCandyImg as integer
global mm_musicButtonSpr as integer
global mm_soundButtonSpr as integer
global mm_priceTagSpr as integer
global mm_priceTagTxt as integer
global mm_helpButtonSpr as integer
global mm_helpButtonTxt as integer


function loadMainMenu()
	
	//set background color
	SetClearColor(41, 209, 131)
	
	//clear previous state and delete all sprites and text from memory
	global_clearState()
	
	//Create Title text
	mm_titleTxt = CreateText("Candy Dragon")
	SetTextFont(mm_titleTxt, global_font)
	SetTextSize(mm_titleTxt, 110)
	SetTextColor(mm_titleTxt,255, 226, 10,255)
	SetTextPosition(mm_titleTxt, 270, 40)
	
	//create a button sprite
	mm_buttonSpr = CreateSprite(global_buttonImg)
	SetSpritePositionByOffset(mm_buttonSpr, windowWidth/2, windowHeight - 130)
	
	//create start game text
	mm_startGameTxt = CreateText("Start Game")
	SetTextFont(mm_startGameTxt, global_font)
	SetTextSize(mm_startGameTxt, 70)
	SetTextPosition(mm_startGameTxt, GetSpriteX(mm_buttonSpr) + 25, GetSpriteY(mm_buttonSpr) + 5)
	
	//create how to play button
	mm_helpButtonSpr = CreateSprite(global_buttonImg)
	SetSpritePositionByOffset(mm_helpButtonSpr, windowWidth/2, windowHeight - 50)
	
	//create how to play text
	mm_helpButtonTxt = CreateText("How to play")
	SetTextFont(mm_helpButtonTxt, global_font)
	SetTextSize(mm_helpButtonTxt, 70)
	SetTextPosition(mm_helpButtonTxt, GetSpriteX(mm_helpButtonSpr) + 20, GetSpriteY(mm_helpButtonSpr) + 5)
	
	//create dragon and think of a random candy
	mm_createDragon(350,250)
	mm_thinkRandomCandy()
	
	//create an instance of the candy sprite the dragon was think of
	image = global_candyImg[mm_dragonCandyImg] //global variable store what image the dragon was think of in mm_thinkRandomCandy
	sprite = CreateSprite(image)
	SetSpriteScale(sprite, 0.6, 0.6)
	SetSpritePosition(sprite, GetSpriteX(mm_dragonSpr) + 150,200)
	
	//create music button
	mm_musicButtonSpr = CreateSprite(global_musicButtonImg[0])
	if musicOn = 0 then SetSpriteImage(mm_musicButtonSpr, global_musicButtonImg[1])
	SetSpriteScale(mm_musicButtonSpr,0.9,0.9)
	SetSpriteDepth(mm_musicButtonSpr,0)
	SetSpritePosition(mm_musicButtonSpr,  windowWidth - 50, windowHeight - 40)
	
	//create sound button
	mm_soundButtonSpr = CreateSprite(global_soundButtonImg[0])
	if soundOn = 0 then SetSpriteImage(mm_soundButtonSpr, global_soundButtonImg[1])
	SetSpriteScale(mm_soundButtonSpr,0.9,0.9)
	SetSpriteDepth(mm_soundButtonSpr,0)
	SetSpritePosition(mm_soundButtonSpr,  windowWidth - 100, windowHeight - 40)
	
	//create price tag sprite in the top left corner
	mm_priceTagSpr = CreateSprite(global_priceTagImg)
	SetSpritePosition(mm_priceTagSpr,GetScreenBoundsLeft(),GetScreenBoundsTop()) 
	SetSpriteShape(mm_priceTagSpr,3)
	
	//create price tag text
	mm_priceTagTxt = CreateText("Get the" + Chr(10) + "source code" + Chr(10) + "Here")
	SetTextPosition(mm_priceTagTxt, GetScreenBoundsLeft() + 35, GetScreenBoundsTop() + 40)
	SetTextSize(mm_priceTagTxt, 30)
	SetTextAlignment(mm_priceTagTxt, 1)
	SetTextAngleRad(mm_priceTagTxt, -0.8)
	
	
	//play music
	global_currentMusic = global_menuMusic
	SetMusicVolumeOGG(global_currentMusic, musicVolume)
	if musicOn = 1 then PlayMusicOGG(global_currentMusic,1)
	
	//set current state to mainManu
	gameState = "mainMenu"
endfunction

function updateMainMenu()
	
     
//PURCHASE SOURCE*****
	//if mouse button is down and it is over the price tag button, change text color to black and open game URL
	if GetSpriteHit(GetPointerX(), GetPointerY()) = mm_priceTagSpr
		SetTextColor(mm_priceTagTxt, 0,0,0,255)
		if GetPointerReleased() then OpenBrowser(global_gameURL)
	else
		SetTextColor(mm_priceTagTxt, 255,255,255,255) //change color of text to white in case the mouse is not over the button and the text is not white
	endif
	
//START GAME*****
	//if mouse button is down and it is over the button, change text color to black and start game
	if GetSpriteHit(GetPointerX(), GetPointerY()) = mm_buttonSpr
		SetTextColor(mm_startGameTxt, 0,0,0,255)
		if GetPointerReleased() then loadGame()
	else
		SetTextColor(mm_startGameTxt, 255,255,255,255) //change color of text to white in case the mouse is not over the button and the text is not white
	endif
	
//HOW TO PLAY*****
	//if mouse button is down and it is over the help button, change text color to black and load how to play screen
	if GetSpriteHit(GetPointerX(), GetPointerY()) = mm_helpButtonSpr
		SetTextColor(mm_helpButtonTxt, 0,0,0,255)
		if GetPointerReleased() then loadHowToPlay()
	else
	    If GetTextExists(mm_helpButtonTxt) then SetTextColor(mm_helpButtonTxt, 255,255,255,255) //change color of text to white in case the mouse is not over the button and the text is not white
	endif
	
//MUSIC****
	//if mouse button is down and it is over the music button, change animation and stop music
	if GetSpriteHit(GetPointerX(), GetPointerY()) = mm_musicButtonSpr
		if GetPointerPressed()
			if GetSpriteImageID(mm_musicButtonSpr) = global_musicButtonImg[0] 
				SetSpriteImage(mm_musicButtonSpr,global_musicButtonImg[1])
				StopMusicOGG(global_currentMusic)
				musicOn = 0
			else
				SetSpriteImage(mm_musicButtonSpr,global_musicButtonImg[0])
				PlayMusicOGG(global_currentMusic,1)
				musicOn = 1
			endif
			
			//save if the music is toggled on or of
			global_saveMusic()
		endif
	endif
	
//SOUND****
	//if mouse button is down and it is over the sound button, change animation and mute sound
	if GetSpriteHit(GetPointerX(), GetPointerY()) = mm_soundButtonSpr
		if GetPointerPressed()
			if GetSpriteImageID(mm_soundButtonSpr) = global_soundButtonImg[0] 
				SetSpriteImage(mm_soundButtonSpr,global_soundButtonImg[1])
				SetSoundSystemVolume(0)
				soundOn = 0
			else
				SetSpriteImage(mm_soundButtonSpr,global_soundButtonImg[0])
				SetSoundSystemVolume(100)
				soundOn = 1
			endif
			
			//save if the sound is toggled on or of
			global_saveSound()
		endif
	endif
	
endfunction

function mm_createDragon(x,y)
	//dragon
	mm_dragonSpr = CreateSprite(global_dragonImg[0])
	for i = 0 to global_dragonImg.length
		AddSpriteAnimationFrame(mm_dragonSpr, global_dragonImg[i])
	next i
	SetSpriteScale(mm_dragonSpr, 0.1, 0.1)
	SetSpritePosition(mm_dragonSpr, x,y)
	SetSpriteShape(mm_dragonSpr, 3)
	SetSpriteSpeed(mm_dragonSpr,1)
	PlaySprite(mm_dragonSpr)
	
	//thought bubble
	mm_dragonBubbleSpr = CreateSprite(global_dragonBubbleImg)
	SetSpriteScale(mm_dragonBubbleSpr, 0.7,0.7)
	SetSpriteDepth(mm_dragonBubbleSpr, 1)
	SetSpritePosition(mm_dragonBubbleSpr, GetSpriteX(mm_dragonSpr) + 10, GetSpriteY(mm_dragonSpr) - 70)
endfunction

function mm_thinkRandomCandy()
	mm_dragonCandyImg = Random2(0,9) 
	if GetSpriteExists(mm_dragonCandySpr) then DeleteSprite(mm_dragonCandySpr)
	mm_dragonCandySpr = CreateSprite(global_candyImg[mm_dragonCandyImg])
	SetSpriteScale(mm_dragonCandySpr,0.2,0.2)
	SetSpriteDepth(mm_dragonCandySpr, 0)
	SetSpritePositionByOffset(mm_dragonCandySpr, GetSpriteXByOffset(mm_dragonBubbleSpr), GetSpriteYByOffset(mm_dragonBubbleSpr))
endfunction
