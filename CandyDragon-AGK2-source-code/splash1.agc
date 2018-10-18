/*
splash state to display who made the game
*/

//globals to reference resources used in the splash1 state
global splash1_Txt as integer
global splash1_timer as float
global splash1_timerTxt as integer
global splash1_titleTxt as integer
global splash1_buttonSpr as integer
global splash1_buttonTxt as integer


function loadSplash1()
	
	//set background color
	SetClearColor(41, 209, 131)
	
	//delete any sprites and texts might be on the screen.
	global_clearState()
	
	//reset the timer in case loading resources took a long time
	ResetTimer()
	
	//Create Title text
	splash1_titleTxt = CreateText("Candy Dragon")
	SetTextFont(splash1_titleTxt, global_font)
	SetTextSize(splash1_titleTxt, 110)
	SetTextColor(splash1_titleTxt,255, 226, 10,255)
	SetTextPosition(splash1_titleTxt, 270, 40)
	
	//Create other text
	splash1_Txt = CreateText("Get the full source code at" + Chr(10) + "    gametemplates.itch.io")
	SetTextSize(splash1_Txt, 50)
	SetTextPosition(splash1_Txt, 250, GetTextY(splash1_titleTxt) + 100)
	
	//create purchase button
	splash1_buttonSpr = CreateSprite(global_buttonImg)
	SetSpritePositionByOffset(splash1_buttonSpr, windowWidth/2, GetTextY(splash1_Txt) + 180)
	
	//create the purchase Text
	splash1_buttonTxt = CreateText("Visit the website")
	SetTextFont(splash1_buttonTxt, global_font)
	SetTextSize(splash1_buttonTxt, 60)
	SetTextPosition(splash1_buttonTxt, GetSpriteX(splash1_buttonSpr) + 5, GetSpriteY(splash1_buttonSpr) + 5)
	
	//create a timer text to display the timer
	splash1_timerTxt = CreateText("The game will start in : 10")
	SetTextSize(splash1_timerTxt, 50)
	SetTextFont(splash1_timerTxt, global_font)
	SetTextColor(splash1_timerTxt,255, 226, 10,255)
	SetTextPosition(splash1_timerTxt, GetSpriteXByOffset(splash1_buttonSpr) - 160, GetSpriteYByOffset(splash1_buttonSpr) + 50)
	
	gameState = "splash1"
endfunction

function updateSplash1()
	
	
//TIMER*****
	//update timer
	splash1_timer = Timer()
	
	//update timer text with timer
	SetTextString(splash1_timerTxt, "The game will start in: " + Str(10 - Floor(splash1_timer)))
	
	
//PURCHASE*****
	//if mouse button is down and it is over the purchase button, change text color to black and open URL
	if GetSpriteHit(GetPointerX(), GetPointerY()) = splash1_buttonSpr
		SetTextColor(splash1_buttonTxt, 0,0,0,255)
		if GetPointerReleased() then OpenBrowser(global_gameURL)
	else
		SetTextColor(splash1_buttonTxt, 255,255,255,255) //change color of text to white in case the mouse is not over the button and the text is not white
	endif
	
//LOAD NEXT SCREEN
	//if timer is > then 10 seconds, load splash 2
	if splash1_timer >= 10 then loadSplash2()
	
endfunction
