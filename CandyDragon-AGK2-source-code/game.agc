

//globals to store reference to all resources used in the game state
global game_targetTime as float //time in seconds when the game is finished
global game_backgroundSpeed as integer
global game_backgroundSpr as integer[1]

global game_dragonSpr as integer
global game_dragonSpeed as integer
global game_dragonCandyImg as integer //the candy the dragon think of
global game_dragonCandySpr as integer
global game_dragonBubbleSpr as integer
global game_dragonHealth as float

global game_candySpr as candy[]
global game_candyTimer as float
global game_candySpeed as float
global game_candySpawnSpeed as float
global game_candyMaxSpeed as float
global game_candyMaxSpawnSpeed as float
global game_candySpawnPoint as integer[4]
global game_candyScore as integer
global game_candyDamage as integer

global game_scoreTxt as integer
global game_score as integer

global game_healthSpr as integer
global game_healthBgSpr as integer

global game_lastCollision as integer

global game_difficultyTimer as float
global game_difficultySpeed as integer

global game_musicButtonSpr as integer
global game_soundButtonSpr as integer

global game_timerTxt as integer

type candy
	animation as integer
	sprite as integer
endtype 

function loadGame()
	
	//set background color
	SetClearColor(0, 0, 0)
	
	//delete previous state and all sprites and text from memory
	global_clearState()
	
	//reset timer
	game_difficultyTimer = 0
	
	//reset values
	game_targetTime = 100 //after 100 seconds, the game will end
	game_difficultySpeed = 3 //increase difficulty every 3 seconds
	game_backgroundSpeed = 1
	game_score = 0
	game_dragonHealth = 100
	game_dragonSpeed = 4
	game_candySpeed = 5
	game_candySpawnSpeed = 1
	game_candyMaxSpeed = 10
	game_candyMaxSpawnSpeed = 0.4
	game_candyScore = 20
	game_candyDamage = 25
	
	//set spawn points for the candies
	game_candySpawnPoint[0] = 20
	game_candySpawnPoint[1] = 150
	game_candySpawnPoint[2] = 200
	game_candySpawnPoint[3] = 280
	game_candySpawnPoint[4] = 340
	
	//create 2 instances of the background sprite
	for i = 0 to game_backgroundSpr.length 
		game_backgroundSpr[i] = CreateSprite(global_backgroundImg)
		SetSpriteDepth(game_backgroundSpr[i], 10)
	next i
	
	//Set position of the second sprite behind the first one
	SetSpriteX(game_backgroundSpr[1], GetSpriteWidth(game_backgroundSpr[0]))
	
	//create dragon
	game_createDragon(10,10)
	
	//pick a random candy for the dragon
	game_thinkRandomCandy()
	
	//play music
	global_currentMusic = global_gameMusic
	SetMusicVolumeOGG(global_currentMusic, musicVolume)
	if musicOn = 1 then PlayMusicOGG(global_currentMusic,1)
	
	//create score text
	game_scoreTxt = CreateText("Score: " + Str(game_score))
	SetTextFont(game_scoreTxt, global_font)
	SetTextSize(game_scoreTxt, 50)
	SetTextPosition(game_scoreTxt, 10, windowHeight - GetTextSize(game_scoreTxt))
	
	//creating the timer text to display the timer at the bottom
	game_timerTxt = CreateText("Time: " + Str(Floor(game_targetTime)))
	SetTextFont(game_timerTxt, global_font)
	SetTextSize(game_timerTxt, 50)
	SetTextPosition(game_timerTxt, 170, windowHeight - GetTextSize(game_timerTxt))
	
	//create health bar
	game_healthBgSpr = CreateSprite(global_healthBarBgImg)
	SetSpriteSize(game_healthBgSpr,150,30)
	SetSpriteDepth(game_healthBgSpr,1)
	SetSpritePosition(game_healthBgSpr, 400, windowHeight - GetSpriteHeight(game_healthBgSpr) - 10)
	
	game_healthSpr = CreateSprite(global_healthBarImg)
	SetSpriteSize(game_healthSpr, GetSpriteWidth(game_healthBgSpr), GetSpriteHeight(game_healthBgSpr))
	SetSpriteDepth(game_healthSpr,0)
	SetSpritePosition(game_healthSpr, GetSpriteX(game_healthBgSpr), GetSpriteY(game_healthBgSpr))
	
	//create music button
	game_musicButtonSpr = CreateSprite(global_musicButtonImg[0])
	if musicOn = 0 then SetSpriteImage(game_musicButtonSpr, global_musicButtonImg[1])
	SetSpriteScale(game_musicButtonSpr,0.9,0.9)
	SetSpriteDepth(game_musicButtonSpr,0)
	SetSpritePosition(game_musicButtonSpr,  windowWidth - 50, windowHeight - 40)
	
	//create sound button
	game_soundButtonSpr = CreateSprite(global_soundButtonImg[0])
	if soundOn = 0 then SetSpriteImage(game_soundButtonSpr, global_soundButtonImg[1])
	SetSpriteScale(game_soundButtonSpr,0.9,0.9)
	SetSpriteDepth(game_soundButtonSpr,0)
	SetSpritePosition(game_soundButtonSpr,  windowWidth - 100, windowHeight - 40)
	
	//set state of the game to game
	gameState = "game"
	
endfunction

function updateGame()
	
//DRAGON******
	//move dragon up if mouse button is down and move it down when it released
	if GetPointerState() = 0
		if GetSpriteY(game_dragonSpr) < 370 then SetSpriteY(game_dragonSpr, GetSpriteY(game_dragonSpr) + game_dragonSpeed )
		if NOT GetSpriteCurrentFrame(game_dragonSpr) = 1 then StopSprite(game_dragonSpr) : SetSpriteFrame(game_dragonSpr,2) //stop animation if no mouse is down
    else
		if GetSpriteY(game_dragonSpr) > 10 then SetSpriteY(game_dragonSpr, GetSpriteY(game_dragonSpr) - game_dragonSpeed)
		if GetSpritePlaying(game_dragonSpr) = 0 then PlaySprite(game_dragonSpr) //play animation if the mouse button is down
	endif
	
//DRAGON BUBBLE*****
	//move the Bubble with the dragon
	SetSpritePosition(game_dragonBubbleSpr, GetSpriteX(game_dragonSpr) + 30, GetSpriteY(game_dragonSpr) - 40)
	//set position of the candy the dragon think of to be the same as the bubble
	SetSpritePosition(game_dragonCandySpr, GetSpriteX(game_dragonBubbleSpr) + 20, GetSpriteY(game_dragonBubbleSpr) + 10)
	
	//ONLY if the dragon is in the air = move backround, spawn and move candies
	if GetSpriteY(game_dragonSpr) < 370
		
//BACKGROUND******
		for i = 0 to game_backgroundSpr.length
			//move background to the left
			SetSpriteX(game_backgroundSpr[i],GetSpriteX(game_backgroundSpr[i]) - game_backgroundSpeed)
			
			//check if the background X position is <= the width of the background, then set it position to be behind the first one
			if GetSpriteX(game_backgroundSpr[i]) <= -GetSpriteWidth(game_backgroundSpr[i]) then SetSpriteX(game_backgroundSpr[i], GetSpriteWidth(game_backgroundSpr[i]))
		next i
	
//CANDY******
		//create a random candy every few seconds at a random location
		game_candyTimer = game_candyTimer + (1*GetFrameTime())
		if game_candyTimer > game_candySpawnSpeed 
			game_createRandomCandy()
			game_candyTimer = 0
		endif
		
		//update the difficulty timer
		game_difficultyTimer = game_difficultyTimer + 1*GetFrameTime()

		//increase difficulty every few seconds
		if game_difficultyTimer >= game_difficultySpeed 
			if game_candySpawnSpeed >= game_candyMaxSpawnSpeed then game_candySpawnSpeed = game_candySpawnSpeed - 0.1
			if game_candySpeed <= game_candyMaxSpeed then game_candySpeed = game_candySpeed + 0.4
			game_difficultyTimer = 0
		endif
		
		//move and delete candies and check collision with the dragon
		for i = 0 to game_candySpr.length
			if GetSpriteExists(game_candySpr[i].sprite)
				
				SetSpriteX(game_candySpr[i].sprite,GetSpriteX(game_candySpr[i].sprite) - game_candySpeed) //move candies to the left
				
				if GetSpriteX(game_candySpr[i].sprite) < -300 then DeleteSprite(game_candySpr[i].sprite) //if candy is outside the screen, delete the candy
				
				if GetSpriteExists(game_candySpr[i].sprite) //if the candy still exists, has not been deleted before
					if GetSpriteCollision(game_candySpr[i].sprite, game_dragonSpr) //check if the candy is in collision with the dragon
						if game_candySpr[i].animation = game_dragonCandyImg //check if the image of the candy is the same what the dragon think of
							
							//if it the same, delete the candy
							DeleteSprite(game_candySpr[i].sprite)
							
							//play gulp sound but only of sound is toggled on
							if soundOn = 1
								if NOT GetSoundsPlaying(global_gulpSnd) then PlaySound(global_gulpSnd, soundVolume)
							endif
							
							//increase score, update score text and think of a new candy
							game_score = game_score + game_candyScore
							SetTextString(game_scoreTxt, "Score: " + Str(game_score))
							game_thinkRandomCandy()
							
						//otherwise if the image of the candy is different then what the dragon want,
						else  
							
							//play the burp sound but only of the sound is toggled on
							if soundOn = 1
								if NOT GetSoundsPlaying(global_burpSnd) then PlaySound(global_burpSnd, soundVolume)
							endif
	
							//if the current candy sprite is NOT the ones the dragon has collided before, only then
							if NOT game_lastCollision = game_candySpr[i].sprite
								//reduce dragon health and update the health bar
								game_dragonHealth = game_dragonHealth - game_candyDamage
								SetSpriteScale(game_healthSpr, game_dragonHealth/100, GetSpriteScaleY(game_healthSpr))
								game_lastCollision = game_candySpr[i].sprite
							endif
							//in case it is the same candy just do nothing to make sure we reducle health only once for each candy
						endif
					endif
				endif
				
			endif
		next i
		
		//after moving all the candy sprites and delete the ones was necessery, also delete the candy object from the array
		for i = 0 to game_candySpr.length
			if NOT GetSpriteExists(game_candySpr[i].sprite) then game_candySpr.remove(i)
		next i
	endif //end of the if statement to check if the dragon is in the air
	
//MUSIC****
	//if mouse button is down and it is over the music button, change animation and toggle music
	if GetSpriteHit(GetPointerX(), GetPointerY()) = game_musicButtonSpr
		if GetPointerPressed()
			if GetSpriteImageID(game_musicButtonSpr) = global_musicButtonImg[0] 
				SetSpriteImage(game_musicButtonSpr,global_musicButtonImg[1])
				StopMusicOGG(global_currentMusic)
				musicOn = 0
			else
				SetSpriteImage(game_musicButtonSpr,global_musicButtonImg[0])
				PlayMusicOGG(global_currentMusic,1)
				musicOn = 1
			endif
			
			//save if the music is toggled on or of
			global_saveMusic()
		endif
	endif
	
//SOUND****
	//if mouse button is down and it is over the sound button, change animation and toggle sound
	if GetSpriteHit(GetPointerX(), GetPointerY()) = game_soundButtonSpr
		if GetPointerPressed()
			if GetSpriteImageID(game_soundButtonSpr) = global_soundButtonImg[0] 
				SetSpriteImage(game_soundButtonSpr,global_soundButtonImg[1])
				SetSoundSystemVolume(0)
				soundOn = 0
			else
				SetSpriteImage(game_soundButtonSpr,global_soundButtonImg[0])
				SetSoundSystemVolume(100)
				soundOn = 1
			endif
			
			//save if the sound is toggled on or of
			global_saveSound()
		endif
	endif
	
	
//TIMER******
	//update the timer and also update the timer text
	game_targetTime = game_targetTime - 1*GetFrameTime()
	SetTextString(game_timerTxt, "Time: " + Str(Floor(game_targetTime)))

//END OF GAME*********
	//if health of dragon is <= 0 or the timer is 0 then go to score screen
	if game_dragonHealth <= 0 then loadScore()
	if game_targetTime <= 0 then loadScore()
	
	
	
endfunction

function game_createRandomCandy()
	image = Random2(0,9) //pick a random image
	id as candy //create a candy object
	id.sprite = CreateSprite(global_candyImg[image])
	id.animation = image
	game_candySpr.insert(id) //add candy object to array
	SetSpriteScale(id.sprite,0.5,0.5)
	SetSpritePosition(id.sprite, 900, game_candySpawnPoint[Random2(0,4)])
	SetSpriteShape(id.sprite,3)
	SetSpriteDepth(id.sprite, 0)
endfunction

function game_thinkRandomCandy()
	game_dragonCandyImg = Random2(0,9) 
	if GetSpriteExists(game_dragonCandySpr) then DeleteSprite(game_dragonCandySpr)
	game_dragonCandySpr = CreateSprite(global_candyImg[game_dragonCandyImg])
	SetSpriteScale(game_dragonCandySpr,0.2,0.2)
	SetSpriteDepth(game_dragonCandySpr, 1)
	SetSpritePositionByOffset(game_dragonCandySpr, GetSpriteXByOffset(game_dragonBubbleSpr), GetSpriteYByOffset(game_dragonBubbleSpr))
endfunction

function game_createDragon(x,y)
	//dragon
	game_dragonSpr = CreateSprite(global_dragonImg[0])
	for i = 0 to global_dragonImg.length
		AddSpriteAnimationFrame(game_dragonSpr, global_dragonImg[i])
	next i
	SetSpriteScale(game_dragonSpr, 0.1, 0.1)
	SetSpritePosition(game_dragonSpr, x,y)
	SetSpriteDepth(game_dragonSpr,1)
	SetSpriteShape(game_dragonSpr, 3)
	SetSpriteSpeed(game_dragonSpr,1)
	PlaySprite(game_dragonSpr)
	
	//thought bubble
	game_dragonBubbleSpr = CreateSprite(global_dragonBubbleImg)
	SetSpriteScale(game_dragonBubbleSpr, 0.5,0.5)
	SetSpriteDepth(game_dragonBubbleSpr, 2)
	SetSpritePosition(game_dragonBubbleSpr, GetSpriteX(game_dragonSpr) + 30, GetSpriteY(game_dragonSpr) - 40)
	SetSpriteDepth(game_dragonBubbleSpr,1)
endfunction
