
/* 
PLEASE REED THE LICENSE.TXT BEFORE USING THIS TEMPLATE, IN CASE THE LICENSE IS MISSING PLEASE CONTACT US AT THE EMAIL BELOW
BY USING THIS TEMPLATE YOU AGREE TO THE LICENSE

Project: candy-dragon
Created: 2018-04-03
Author: Laszlo Koosz
EMAIL: gametemplates.itch@gmail.com
*/

//variables for debugging
global debugInt as integer
global debugStr as string

//default game properties
global windowWidth as integer = 960
global windowHeight as integer = 480
global gameState as string // we load the splash1 state first by default
global musicVolume as integer = 20
global soundVolume as integer = 40
global musicOn as integer = 1
global soundOn as integer = 1

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "candy-dragon" )
SetWindowSize( windowWidth, WindowHeight, 0)
SetWindowAllowResize( 0 ) // don't allow the user to resize the window

// set display properties
SetVirtualResolution( windowWidth, windowHeight )
SetOrientationAllowed( 0, 0, 1, 0 ) // allow only landscape on mobile devices
SetSyncRate( 60, 0 ) // set maximum FPS to 60 for a smooth experience
SetScissor( GetScreenBoundsLeft(),GetScreenBoundsTop(),GetScreenBoundsRight(),GetScreenBoundsBottom() ) // use the maximum available screen space
UseNewDefaultFonts( 1 )

Sync() //make sure everything is updated before going any further, it helps to avoid problems with device orientation, resolution and aspect ratio

#include "keycodes.agc"
#include "loadresources.agc"
#include "howtoplay.agc"
#include "splash1.agc"
#include "splash2.agc"
#include "mainmenu.agc"
#include "game.agc"
#include "score.agc"

//load resources
loadResources()

//load splash screen
loadSplash1()


//update the game
do
    //if we are in the game state, update the game, otherwise check what state we are in
    if gameState = "game" 
		updateGame()
    else 
		if gameState = "howtoplay" then updateHowToPlay()
		if gameState = "mainMenu" then updateMainMenu()
		if gameState = "score" then updateScore()
		if gameState = "splash1" then updateSplash1()
		if gameState = "splash2" then updateSplash2()
	endif
	
    Sync()
loop
