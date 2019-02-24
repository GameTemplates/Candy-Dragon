using Godot;
using System;

public class Background : Node2D
{
    private int movementSpeed;
	private float screenWidth;

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
		
		//initialize values
		movementSpeed = 100;
		screenWidth = GetViewport().GetSize().x;
        
    }

    public override void _Process(float delta)
    {
        // Called every frame. Delta is time since last frame.
        // Update game logic here.
        
		//get current position
		var posX = this.Position.x;
		var posY = this.Position.y;
		
		//move it to the left
		posX -= 100 * delta;
		
		//note: image is imported as Repeat and using Region property to make it a tiled sprites
		//if image is about to leave on the left, reset it position
		if(posX <= 0)
			posX = screenWidth;
		
		//update position
		this.SetPosition(new Vector2(posX, posY));
    }
}
