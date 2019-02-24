using Godot;
using System;

public class GameOver : Node
{

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
		
		//update score text to display the score
		var scoreText = (RichTextLabel)this.GetNode("Score");
		scoreText.Text = "Your Score is: " + Game.score.ToString();
        
    }

//    public override void _Process(float delta)
//    {
//        // Called every frame. Delta is time since last frame.
//        // Update game logic here.
//        
//    }

	private void _onButtonPressed()
	{
    	// sending a signal if button pressed
		
		//go back to game
		GetTree().ChangeScene("Game.scn");
	}
}

