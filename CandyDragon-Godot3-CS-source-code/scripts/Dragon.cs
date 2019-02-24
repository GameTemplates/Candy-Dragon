using Godot;
using System;

public class Dragon : Node2D
{
    private float movementSpeed;
	private float dragonWeight;
	private AnimatedSprite dragonSprite;
	
	private AnimatedSprite candySprite;
	private int randomCandy;
	
	private float spriteHeight;
	private float screenHeight;
	
	private AudioStreamPlayer burpSound;
	private AudioStreamPlayer gulpSound;
	
	public static float life; //public value, we can access it with Dragon.life

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        
		//initialize values
		movementSpeed = 150;
		dragonWeight = 1.0f; //used to controll falling speed
		life = 1;
		
		//get reference to the gulp and burp sound
		gulpSound = (AudioStreamPlayer)this.GetNode("gulp-sound");
		burpSound = (AudioStreamPlayer)this.GetNode("burp-sound");
		
		//get reference to dragon sprite
		dragonSprite = (AnimatedSprite)this.GetNode("dragon-sprite");
		
		//get reference to the candy sprite
		candySprite = (AnimatedSprite)this.GetNode("candy-sprite");
		
		//get dragon sprite height
		spriteHeight = dragonSprite.GetSpriteFrames().GetFrame("default",0).GetHeight() * this.GetScale().y;
	
		//get screen height
		screenHeight = this.GetViewport().Size.y;
		
		//pick a random candy animtion
		randomCandy = Game.rnd.Next(1,10);
		candySprite.Animation = randomCandy.ToString();
    }

    public override void _Process(float delta)
    {
        // Called every frame. Delta is time since last frame.
        // Update game logic here.
        
		//get dragon current position
		var posX = this.Position.x;
		var posY = this.Position.y;
		
		/************
		MOVE DRAGON
		************/
		
		//if left mouse button is down, move th draggon up and play animation
		if(Input.IsActionPressed("fly"))
		{
			if(posY > spriteHeight/2) //make sure dragon stop at the top of the screen
			{
				dragonSprite.Playing = true;
				posY -= (movementSpeed - (dragonWeight * 4)) * delta; //we also take the dragon weight in to account
			}
		}
		else //if mouse button is not pressed, stop animation and move dragon down
		{
			if(posY < screenHeight - 50 - spriteHeight/2) //make sure dragon stop at the bottom of the screen
			{
				dragonSprite.Frame = 1;
				dragonSprite.Playing = false;
				posY += (float)(movementSpeed * dragonWeight) * delta;
			}
		}
		
		//update dragon position
		this.SetPosition(new Vector2(posX, posY));
		
    }
	
	private void _onCollisioMaskAreaEntered(Node2D node)
	{
    	// sending a signal if something colliding with the dragon
		
		//assuming it is a candy, get sprite node of the colliding node
		var sprite = (AnimatedSprite)node.GetParent().GetNode("sprite");

		//check if the animation of the colliding node is the same as the candy-sprite
		if(candySprite.Animation == sprite.Animation)
		{
			//play the gulp sound
			gulpSound.Play();
			
			//pick a new random candy
			randomCandy = Game.rnd.Next(1,10);
			candySprite.Animation = randomCandy.ToString();
			
			//increase dragon weight
			dragonWeight += 0.2f;
			
			//delete the node we have collided with, it is locked in the current frame so we put it in a queue
			node.GetParent().QueueFree();
			
			//increase score by 20
			Game.score += 20;
			
		}
		else //otherwise reduce the dragn health
		{
			//play burp sound
			burpSound.Play();
			
			//reduce life
			life -= 0.2f;
			GD.Print("damage");
		}
	}
	
}
