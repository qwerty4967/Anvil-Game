﻿package 
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.display.FrameLabel;
	
	public class Main extends flash.display.MovieClip
	{
		
		//COOKIES!! (naturaly, for the cookie monster.)
		var cookie:SharedObject = SharedObject.getLocal("masonGameCookie2");

		public static var score:int = 0; //scoring is done by the anvil class.
		var health:int = 1;//max 4, if it hits 0, you lose.
		
		var moveLeft:Boolean=false; // check if the player is trying to move left or right.
		var moveRight:Boolean=false;	
		
		
		//init the health icons
		var HP1OFF=new healthLow();
		var HP2OFF=new healthLow();
		var HP3OFF=new healthLow();
		
		
		var HP1ON=new healthHigh();
		var HP2ON=new healthHigh();
		var HP3ON=new healthHigh();
		
		//init player
		var Player=new playerBody();
		
		// init timers
		var timer:Timer = new Timer(25);
		var winTimer:Timer = new Timer(5000);
				
		private var _keysPressed:Object = { };
				
				
		public function Main()
		{
			
			
			stop(); // keeps everything under control.
			frameControl(1); // initiate everything and get it under control.
			
		}
		
		
		
		public function frameControl(frame)
		{				
			
			
			gotoAndStop(frame);
			
			
			if(this.currentFrame==1) // init intro frame.
			{
				
				// add event listeners
				playButton.addEventListener(MouseEvent.CLICK, startGame);
				
				
			}
			
			if(this.currentFrame==2) // init game.
			{
				
				// define the giblets
				this.HP1OFF.y=210;
				this.HP2OFF.y=130;
				this.HP3OFF.y=50;
				
				this.HP1ON.y=210;
				this.HP2ON.y=130;
				this.HP3ON.y=50;
				
				anvilone.scoring=true;
				anvilGold2.Active=false;
				anvilGold3.Active=false;
				anvilGold4.Active=false;
				anvilGold5.Active=false;
				anvilGold6.Active=false;
				
				// Setup health
				health=1;
				
				addChild(HP1OFF);
				addChild(HP2OFF);
				addChild(HP3OFF);
				
				
				// Setup player:
				
				this.Player.x=150;
				this.Player.y=240;
				stage.stageFocusRect = false;
				stage.focus= Player;
				
				if(! stage.contains(Player))
				{
					addChild(Player);
				}
				
				
				//Setup Highscore:
				if(cookie.data.highScore==undefined)
				{
					cookie.data.highScore=0;
				}
				
				highScoreText.text="High Score: "+cookie.data.highScore;
				
				
				//Event listeners:
				timer.addEventListener("timer", playerMovement); //get the player moving.
				winTimer.addEventListener("timer", winEnd);
				stage.addEventListener ( KeyboardEvent.KEY_DOWN, reportKeyDown ); 
				stage.addEventListener ( KeyboardEvent.KEY_UP, reportKeyUp ); 
				
				// get the game running.
				timer.start();
			}
			
			if(this.currentFrame==3)
			{
				// Write the scores:
				scoreOut.text="Your final score was: "+score.toString();
				highScoreOut.text="High Score: "+cookie.data.highScore;
				
				//reset the score
				score=0;
				
				//Event listeners:
				playButton.addEventListener(MouseEvent.CLICK, Replay);
				
				
			}
			if(this.currentFrame==4)
			{
				playButton.addEventListener(MouseEvent.CLICK, Replay);
			}
		}
		
		
		function startGame(e:MouseEvent) // this brings you to the actual game.
		{
			//goto game
			frameControl(2);
		
		}
		
		
		
		
		
		
		
		function detectCollision() // find anything that hits the players head
		{
			//move the hitboxes with the anvils
			HB1.x=anvilone.x+11;
			HB1.y=anvilone.y;
			HB2.x=anviltwo.x+11;
			HB2.y=anviltwo.y;	
			HB3.x=anvilthree.x+11;
			HB3.y=anvilthree.y;
			HB4.x=anvilGold1.x+11;
			HB4.y=anvilGold1.y;
	
			// This is what happens when you hit an anvil.
			if(PlayerHead.hitTestObject(HB1)||PlayerHead.hitTestObject(HB2)||PlayerHead.hitTestObject(HB3)) 
			{
				health--;
				
				anvilone.reroll();
				anviltwo.reroll();
				anvilthree.reroll();
				
			}
			
			// for golden anvil.
			if(PlayerHead.hitTestObject(HB4))
			{
				health++;
				anvilGold1.reroll(); // reset the anvil.
			}
			
			
			scoreManager();			
			healthManager(); //deal with the health system now
			projectileManager(); // Make sure everything is okay with the anvils.
			
		}
		
		
		function winEnd(event:TimerEvent)
		{
			
			timer.stop();
			winTimer.stop();
			anvilone.timer.stop();
			anviltwo.timer.stop();
			anvilthree.timer.stop();
			
			// Get rid of everything else.
			removeChild(Player);
			cookie.flush();
			
			//Systematicly remove health icons from the stage.
			if(stage.contains(HP1OFF))
			{
				removeChild(HP1OFF);
			}
			if(stage.contains(HP2OFF))
			{
					removeChild(HP2OFF);
			}
			if(stage.contains(HP3OFF))
			{
					removeChild(HP3OFF);
			}
			
			if(stage.contains(HP1ON))
			{
				removeChild(HP1ON);
			}
			if(stage.contains(HP2ON))
			{
					removeChild(HP2ON);
			}
			if(stage.contains(HP3ON))
			{
					removeChild(HP3ON);
			}
			
			//goto 'win' screen:
			frameControl(4);
		}
		
		
		function projectileManager() // Deals with projectiles in spicific edge cases
		{
			anvilone.y=anviltwo.y; //make sure anvils don't "shift"
			anvilone.y=anvilthree.y;
			
			//while(true) // make sure anvils are never lined up three in a row.
			//{
			//	if()
			//}
		}
		
		
		function scoreManager() // deals with score*.
		{
		
			scoreText.text="Score: "+score;
			
			if(cookie.data.highScore<score) // increases high score count. (this shouold only happen when you die)
			{
				cookie.data.highScore=score;
				cookie.flush();
				highScoreText.text="High Score: "+cookie.data.highScore;
			}
			
			if(score>=50)
			{
			
				anvilone.Active=false;
				anviltwo.Active=false;
				anvilthree.Active=false;
				
				anvilone.reroll();
				anviltwo.reroll();
				anvilthree.reroll();
				
				anvilGold2.Active=true;
				anvilGold3.Active=true;
				anvilGold4.Active=true;
				anvilGold5.Active=true;
				anvilGold6.Active=true;

				if(!winTimer.running)
				{
					
					winTimer.start();
					
				}
			}
			
		}
		
		
		function healthManager() // this controls everything* to do with health.
		{
			if(health<=0) //you die when your health is zero.
			{
				
				//shutdown all of the timers.
				timer.stop();
				anvilone.timer.stop();
				anviltwo.timer.stop();
				anvilthree.timer.stop();
				
				// Get rid of everything else.
				removeChild(Player);
				cookie.flush();
				
				//Systematicly remove health icons from the stage.
				if(stage.contains(HP1OFF))
				{
					removeChild(HP1OFF);
				}
				if(stage.contains(HP2OFF))
				{
						removeChild(HP2OFF);
				}
				if(stage.contains(HP3OFF))
				{
						removeChild(HP3OFF);
				}
				
				if(stage.contains(HP1ON))
				{
					removeChild(HP1ON);
				}
				if(stage.contains(HP2ON))
				{
						removeChild(HP2ON);
				}
				if(stage.contains(HP3ON))
				{
						removeChild(HP3ON);
				}
				
				//goto death screen,
				frameControl(3);
			}
			
			
			// when your health is at four, it is 'MAX'.
			if(health==4)
			{
				healthText.text="Health: MAX";
			}
			else
			{
				healthText.text="Health: "+health;
			}
			
		
			if(health>4) //limit max health.
			{
				health=4;
			}
			
			
			//Deal with health icons.
			if(health>=2)
			{
				
				if(stage.contains(HP1OFF))
				{
					addChild(HP1ON);
					removeChild(HP1OFF);
				}
				
			}
			
			if(health>=3)
			{
				
				if(stage.contains(HP2OFF))
				{
					addChild(HP2ON);
					removeChild(HP2OFF);
				}
				
			}
			
			if(health==4)
			{
				
				if(stage.contains(HP3OFF))
				{
					addChild(HP3ON);
					removeChild(HP3OFF);
				}
				
			}
			
			if(health<2)
			{
				
				if(stage.contains(HP1ON))
				{
					addChild(HP1OFF);
					removeChild(HP1ON);
				}
			}
			
			if(health<3)
			{
			if(stage.contains(HP2ON))
				{
					addChild(HP2OFF);
					removeChild(HP2ON);
				}
			}
			
			
			if(health<4)
			{
				if(stage.contains(HP3ON))
				{
			
					addChild(HP3OFF);
					removeChild(HP3ON);
				}
			}
		}
		
		
		
		
		function playerMovement( event:TimerEvent)
		{
			
			// Move the player each tick.
			if(moveLeft)
			{
				PlayerHead.x=PlayerHead.x-6;
				
				if(Player.currentFrame<17)
				{
					Player.gotoAndPlay(18);
				}
				
			}
			
			if(moveRight)
			{
				PlayerHead.x=PlayerHead.x+6;
				
				if(Player.currentFrame==1||Player.currentFrame>=17)
				{
					Player.gotoAndPlay(3);
				}
				
			}
			
			if(!moveLeft && !moveRight)
			{
				Player.gotoAndStop(1);
			}
			
			// manage boundries (kinda crude, but whatever.)
			if(PlayerHead.x<150)
			{
				PlayerHead.x=150;
			}
			if(PlayerHead.x>400)
			{
				PlayerHead.x=400;
			}
			
			//Move the the body with player's head.
			Player.x=PlayerHead.x;
			PlayerHead.y=300-(PlayerHead.height+Player.height)
			Player.y=PlayerHead.y+PlayerHead.height-2.5;
			
			
			// find various objects that hit the players head.
			detectCollision();
		}
		

		function reportKeyDown( event:KeyboardEvent )
		{
			 _keysPressed[event.keyCode] = true;
			if ( event.keyCode == Keyboard.LEFT ) // 
			{
			
				moveLeft=true;
				
			}
			if ( event.keyCode == Keyboard.RIGHT ) // Move the player right
			{
				
				moveRight=true;
				
			}
			if ( _keysPressed[Keyboard.C]&&_keysPressed[Keyboard.R]&&_keysPressed[Keyboard.A]&&_keysPressed[Keyboard.B]) // SUPER SECRET CRAB MODE!!!!
			{
				
				anvilone.gotoAndStop(2);
				anviltwo.gotoAndStop(2);
				anvilthree.gotoAndStop(2);
			}
			
			if ( event.keyCode == Keyboard.P ) // Debug some more score.
			{
				
				score=50;
				
			}
			
			
		}

		

		
		function reportKeyUp( event:KeyboardEvent )
		{
			
			if ( event.keyCode == Keyboard.LEFT ) // 
			{
			
				moveLeft=false;
				
			}
			if ( event.keyCode == Keyboard.RIGHT ) // Move the player right
			{
				
				moveRight=false;
				
			}
			
		}
		
		
		
		function Replay(e:MouseEvent) 
		{
			
			cookie.flush();
			frameControl(2);
			
		}

	}
}
