
/*
the screen displaying information on how to play the game, you can create a tutorial here if you want
*/

//globals to store reference to resources used in the how to play screen
global htp_Txt as integer
global htp_titleTxt as integer
global htp_buttonSpr as integer
global htp_buttonTxt as integer
global htp_dragonBubbleSpr as integer

function loadHowToPlay()
	//set background color
	SetClearColor(41, 209, 131)
	
	//delete the content of the previous state.
	global_clearState()
	
	//Create Title text
	htp_titleTxt = CreateText("Candy Dragon")
	SetTextFont(htp_titleTxt, global_font)
	SetTextSize(htp_titleTxt, 110)
	SetTextColor(htp_titleTxt,255, 226, 10,255)
	SetTextPosition(htp_titleTxt, 270, 40)
	
	//create text displaying the info
	text as string =        "      Tap the screen to move the dragon up and release it to move it down"
	text = text + Chr(10) + "Collect all the candies the dragon think of       and avoid all the other candies" 
	text = text + Chr(10) + "             The game last 100 seconds or until the dragon run out of life" 
	text = text + Chr(10) + "                            Try to collect as many candies as you can"
	htp_Txt = CreateText(text) 
	SetTextSize(htp_Txt, 35 )
	SetTextPosition(htp_Txt, 10, GetTextY(htp_titleTxt) + 100)
	
	//create a thought bubble in the top of the text
	htp_dragonBubbleSpr = CreateSprite(global_dragonBubbleImg)
	SetSpriteScale(htp_dragonBubbleSpr, 0.35,0.4)
	SetSpritePosition(htp_dragonBubbleSpr,GetTextX(htp_Txt) + 513, GetTextY(htp_Txt) + 30)
	
	//create button
	htp_buttonSpr = CreateSprite(global_buttonImg)
	SetSpritePositionByOffset(htp_buttonSpr, windowWidth/2, GetTextY(htp_Txt) + 290)
	
	//create button text
	htp_buttonTxt = CreateText("Back")
	SetTextFont(htp_buttonTxt, global_font)
	SetTextSize(htp_buttonTxt, 100)
	SetTextPosition(htp_buttonTxt, GetSpriteX(htp_buttonSpr) + 50, GetSpriteY(htp_buttonSpr) - 10)
	
	gameState = "howtoplay"
endfunction

function updateHowToPlay()
	
	//if mouse button is down and it is over the button, change text color to black and load main menu
	if GetSpriteHit(GetPointerX(), GetPointerY()) = htp_buttonSpr
		SetTextColor(htp_buttonTxt, 0,0,0,255)
		if GetPointerReleased() then loadMainMenu()
	else
		SetTextColor(htp_buttonTxt, 255,255,255,255) //change color of text to white in case the mouse is not over the button and the text is not white
	endif
	
endfunction
