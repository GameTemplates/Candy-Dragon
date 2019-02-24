using Godot;
using System;

public class Credit : Node
{
   	private float timer;

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
		
		timer = 5; //after 5 seconds, go to main menu
        
    }

    public override void _Process(float delta)
    {
        // Called every frame. Delta is time since last frame.
        // Update game logic here.
		
		//update timer
		timer -= delta;
		
		//if timer <= 0, go to main menu
		if(timer <= 0)
			GetTree().ChangeScene("MainMenu.scn");
        
    }
}
