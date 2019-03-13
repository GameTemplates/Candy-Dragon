using Godot;
using System;

public class Candy : Node2D
{
    private int movementSpeed;
	private AnimatedSprite sprite;
	private float spriteWidth;

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
		
		//initialize values
		movementSpeed = 300;
		
		//get reference to the sprite
		sprite = (AnimatedSprite)this.GetNode("sprite");
		
		//get the width of the sprite
		spriteWidth = sprite.GetSpriteFrames().GetFrame("1",0).GetWidth();
		
		//pick a random animation
		sprite.Animation = Game.rnd.Next(1,10).ToString();
		
		//enable the corresponding collision mask for the animation
		var collisionMask = (CollisionPolygon2D)this.FindNode("collision-shape" + sprite.Animation.ToString());
		collisionMask.Disabled = false;
        
    }
	
    public override void _Process(float delta)
    {
        // Called every frame. Delta is time since last frame.
        // Update game logic here.
		
		/*NOTE: 
		if the candy colliding with the dragon
		and the animation of the candy is the same as the dragon-candy, we delete the candy
		it is handled in Dragon.cs because by the timer we trigger the collision event here, we change the animation of the dragon-candy
		*/
		
		//get current position
		var posX = this.Position.x;
		var posY = this.Position.y;
		
		// move candy to the left at the given speed
		posX -= movementSpeed * delta;
		
		//update position
		this.SetPosition(new Vector2(posX, posY));
		
		//if the candy left the screen on the left, delete the candy
		if(posX <= 0 - spriteWidth)
			this.Free();
    }
}
