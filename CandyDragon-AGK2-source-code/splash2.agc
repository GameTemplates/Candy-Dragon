/*
splash to attribute Eric Matyas for the music, in case you would like to use any of the music in you own project, you need to attribute him.
*/

//globals to reference resources used in splash2 screen
global splash2_Txt as integer
global splash2_timer as float

function loadSplash2()
	
	//set background color
	SetClearColor(41, 209, 131)
	
	//delete the content of the previous state.
	global_clearState()
	
	//reset the timer in case loading resources took a long time
	ResetTimer()
	
	//create the text to attribute Eric Matyas
	splash2_Txt = CreateText(" Music by Eric Matyas" + Chr(10) + "www.soundimage.org")
	SetTextSize(splash2_Txt,70)
	SetTextPosition(splash2_Txt, 200, 150)
	SetTextColor(splash2_Txt,255, 226, 10,255)
	
	gameState = "splash2"
endfunction

function updateSplash2()
	
	//update the timer
	splash2_timer = Timer()
	
	//after 5 seconds, load the main menu
	if splash2_timer >= 5 then loadMainMenu()
	
	
endfunction
