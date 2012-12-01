package com.saybot.vbpuzzles.challengeBeast.view
{
	import com.saybot.vbpuzzles.challengeBeast.ChallengeBeast;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Rock extends Sprite
	{
		private var _active:Boolean = true;
		private var rock:MovieClip;
		private var speedY:Number = 0;
		private var baseY:int;
		private var timer:Timer;
		
		public function Rock(view:MovieClip)
		{
			super();
			rock = view;
			baseY = view.y;
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function kick():void
		{
			_active = false;
			addEventListener(Event.ENTER_FRAME, fall);
		}
		
		private function fall(e:Event):void
		{
			rock.y += speedY++;
			if(ChallengeBeast.beast != null
			&& Math.abs(ChallengeBeast.beast.view.x - rock.x) < ChallengeBeast.beast.view.width/2
			&& Math.abs(ChallengeBeast.beast.view.y - rock.y) < ChallengeBeast.beast.view.height){
				removeEventListener(Event.ENTER_FRAME, fall);
				ChallengeBeast.stoneSoundCtrl.playSound();
				speedY = 0;
				addEventListener(Event.ENTER_FRAME, disappear);
				ChallengeBeast.beast.hurt();
			}
			
			if(rock.y > SkeletonAvatar.SCENE_HEIGHT){
				removeEventListener(Event.ENTER_FRAME, fall);
				ChallengeBeast.stoneSoundCtrl.playSound();
				speedY = 0;
				addEventListener(Event.ENTER_FRAME, disappear);
			}
		}
		
		private function disappear(e:Event):void
		{
			rock.alpha -= 0.05;
			if(rock.alpha <= 0){
				removeEventListener(Event.ENTER_FRAME, disappear);
				timer = new Timer(10000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, restart);
				timer.start();		
			}
		}
		
		private function restart(e:Event):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, restart);
			rock.y = baseY;
			addEventListener(Event.ENTER_FRAME, appear);
		}
		
		private function appear(e:Event):void
		{
			rock.alpha += 0.05;
			if(rock.alpha >= 1){
				removeEventListener(Event.ENTER_FRAME, appear);
				this._active = true;
			}
		}
		
		
	}
}