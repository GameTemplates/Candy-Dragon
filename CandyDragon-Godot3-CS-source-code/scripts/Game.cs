using Godot;
using System;

public class Game : Node
{
   	public static Random rnd = new Random(); //this is public so we can access it using Game.rnd
	private PackedScene candy;
	private float spawnTimer;
	private float spawnTime;
	private Vector2[] candyPos = new Vector2[4];
	private AudioStreamPlayer gameMusic;
	private float gameTime;
	
	public static int score; //public value that we can access with Game.score
	private RichTextLabel scoreText;
	
	private Sprite lifeBar;
	
    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
		
		//initialize values here
		spawnTime = 1;
		score = 0;
		gameTime = 60; //60 seconds and then game over
		
		//get reference to game music
		gameMusic = (AudioStreamPlayer)this.GetNode("game-music");
		
		//play music
		gameMusic.Play();
		
		//get a refernce to the scene containing the candy
		candy = (PackedScene)ResourceLoader.Load("res://objects/Candy.tscn");
		
		//get reference to score text
		scoreText = (RichTextLabel)this.GetNode("score-text");
		
		//get reference to the life bar
		lifeBar = (Sprite)this.FindNode("life-bar");
		
		//we have 3 specific locations where to spawn candy
		candyPos[1] = new Vector2(1000,50); //top
		candyPos[2] = new Vector2(1000,210); //middle
		candyPos[3] = new Vector2(1000,360); //bottom
		
		//spawn a candy at a random location
		spawnCandy();
        
    }

    public override void _Process(float delta)
    {
        // Called every frame. Delta is time since last frame.
        // Update game logic here.
		
		//update timer
		spawnTimer += delta;
		
		//if timer >= spawn time, spawn a candy at a random position
		if(spawnTimer >= spawnTime)
		{
			spawnCandy();
			spawnTimer = 0;
		}
		
		//update score text with score
		scoreText.Text = "Score: " + score.ToString();
		
		//update life bar scale width with the life of the dragon
		lifeBar.SetScale(new Vector2(Dragon.life, 1));
		
		
		//reduce game time
		gameTime -= delta;
		
		//if game time <= 0 game over
		if(gameTime <= 0)
		{
			GetTree().ChangeScene("GameOver.scn");
		}
		
		//if dragon life <= 0 game over
		if(Dragon.life <= 0)
		{
			GetTree().ChangeScene("GameOver.scn");
		}
        
    }
	
	private void spawnCandy()
	{
		var candyInstance = (Node2D)candy.Instance();
		var randomPos = Game.rnd.Next(1,4);
		candyInstance.SetPosition(new Vector2(candyPos[randomPos].x, candyPos[randomPos].y));
		this.AddChild(candyInstance);
	}
}
