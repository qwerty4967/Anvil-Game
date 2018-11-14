﻿package 
{
	
	import flash.display.SimpleButton;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	
	
	public class Anvil extends flash.display.MovieClip
	{
		
		
		public var timer:Timer = new Timer(25);
		var speedmult:int=0;
		var scoring:Boolean = false;
		public var Active:Boolean = true;
		
		public function Anvil()
		{
			

			timer.addEventListener("timer", controlFall); //controls the falling.
			timer.start();
		}
		
		
		
		function controlFall(event:TimerEvent)
		{
			if(Active)
			{
				this.y=this.y+(2+(speedmult*0.18));
			}
			
			if(this.y>275)
			{
				if(scoring)
				{
					Main.score++;
				}
				speedmult++;
				reroll();
				
			}
			
		}
		
		
		function reroll()
		{
			this.y=-50;
			this.x= ((Math.floor(Math.random() * 6))*50)+150;
		
		}
	}
}
