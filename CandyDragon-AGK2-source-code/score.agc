

//globals to reference resources required in the score state
global score_buttonSpr as integer
global score_restartTxt as integer
global score_Txt as integer
global score_bestScore as integer
global score_bestScoreTxt as integer

function loadScore()
	
	//set best score to 0
	score_bestScore = 0
	
	//if _bestscore save exists, load the last saved best score
	if GetFileExists(global_saveBestScoreFile)
		saveFile = OpenToRead(global_saveBestScoreFile)
		score_bestScore = ReadInteger(saveFile)
		CloseFile(saveFile)
	endif
	
	//if the best score is less then the current score, save the current score and update the best score
	if score_bestScore < game_score
		score_bestScore = game_score
		
		saveFile = OpenToWrite(global_saveBestScoreFile)
		WriteInteger(saveFile, game_score)
		CloseFile(saveFile)
	endif
	
	//set background color
	SetClearColor(41, 209, 131)
	
	//clear previous state and delete all sprites and text from memory
	global_clearState()
	
	//play music
	global_currentMusic = global_endMusic
	SetMusicVolumeOGG(global_currentMusic, musicVolume)
	if musicOn = 1 then PlayMusicOGG(global_currentMusic,1)
	
	//create a text to display best score
	score_Txt = CreateText("Your score is " + Str(game_score))
	SetTextFont(score_Txt,global_font)
	SetTextSize(score_Txt,100)
	SetTextPosition(score_Txt, 270, 40)
	SetTextColor(score_Txt,255, 226, 10,255)
	
	//create text display current score
	score_bestScoreTxt = CreateText("Your best score is " + Str(score_bestScore))
	SetTextFont(score_bestScoreTxt,global_font)
	SetTextSize(score_bestScoreTxt,100)
	SetTextPosition(score_bestScoreTxt, 210, GetTextY(score_Txt) + 60)
	SetTextColor(score_bestScoreTxt,255, 226, 10,255)
	
	//Create a restart game button
	score_buttonSpr = CreateSprite(global_buttonImg)
	SetSpritePositionByOffset(score_buttonSpr, windowWidth/2, GetTextY(score_Txt) + 200)
	
	//create restart text
	score_restartTxt = CreateText("Restart Game")
	SetTextFont(score_restartTxt, global_font)
	SetTextSize(score_restartTxt, 70)
	SetTextPosition(score_restartTxt, GetSpriteX(score_buttonSpr) + 5, GetSpriteY(score_buttonSpr) + 3)
	
	//change current state to score
	gameState = "score"
endfunction

function updateScore()
	
	//if mouse button is down and it is over the restart button, change text color to black and load the main menu
	if GetSpriteHit(GetPointerX(), GetPointerY()) = score_buttonSpr
		SetTextColor(score_restartTxt, 0,0,0,255)
		if GetPointerReleased() then loadMainMenu()
	else
		SetTextColor(score_restartTxt, 255,255,255,255) //change color of text to white in case the mouse is not over the button and the text is not white
	endif
	
endfunction
