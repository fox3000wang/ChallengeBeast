package com.saybot.vbpuzzles.challengeBeast
{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	import com.saybot.vbpuzzles.challengeBeast.view.Rock;
	import com.saybot.vbpuzzles.challengeBeast.view.SkeletonAvatar;
	import com.saybot.vbpuzzles.challengeBeast.view.SkeletonBeast;
	import com.saybot.vbpuzzles.challengeBeast.sound.SoundCtrl;
	
	public class ChallengeBeast extends Sprite
	{
		static public var INSTANCE:ChallengeBeast;
		
		public var loader:Loader = new Loader();
		
		static public var walkArea:Array = [];
		static public var rockArea:Array = []
		
		static public var scene:*;
		static public var fg:DisplayObject;
		static public var help:DisplayObject;
		static public var win:*;
		static public var lose:DisplayObject;
		
		static public var avatar:SkeletonAvatar;		
		static public var beast:SkeletonBeast;
		
		static public var sceneSoundCtrl:SoundCtrl;
		static public var successSoundCtrl:SoundCtrl;
		static public var loseSoundCtrl:SoundCtrl;
		static public var stoneSoundCtrl:SoundCtrl;
		static public var bossAttackSoundCtrl:SoundCtrl;
		
		private var timer:Timer;
		
		public static var avatarClass:Class;
		
		public function ChallengeBeast()
		{
			super();
			loadSwfComplateHandler();
			
			sceneSoundCtrl      = new SoundCtrl(new EmbedResource.sceneMusicClass,true);
			successSoundCtrl    = new SoundCtrl(new EmbedResource.successMusicClass);
			loseSoundCtrl       = new SoundCtrl(new EmbedResource.loseMusicClass);
			stoneSoundCtrl      = new SoundCtrl(new EmbedResource.stoneSoundClass);
			bossAttackSoundCtrl = new SoundCtrl(new EmbedResource.bossAttackSoundClass);
			
			INSTANCE = this;
		}
		
		private function loadSwfComplateHandler(e:Event = null):void{
			scene = new EmbedResource.sceneClass();
			addChild(scene);
			
			for(var i:int = 0; scene.getChildByName("floor_" + i) != null; i++){
				var floor:MovieClip = scene.getChildByName("floor_" + i) as MovieClip;
				walkArea.push({"xFrom":floor.x,"xTo":floor.x + floor.width,"y":floor.y});
			}
			
			for(var j:int = 0; scene.getChildByName("rock_" + j) != null; j++){
				var rock:MovieClip = scene.getChildByName("rock_" + j) as MovieClip;
				rockArea.push({"xFrom":rock.x,"xTo":rock.x + rock.width,"y":rock.y,"view":new Rock(rock)});
			}
			
			beast = new SkeletonBeast();
			scene.addChild(beast);
			avatar = new SkeletonAvatar();
			scene.addChild(avatar);
			
			fg = scene["fg"];
			fg["avatarHp"].gotoAndStop(1);
			addChild(fg);
			addChildAt(scene["bg"],0);
			
			help = new EmbedResource.helpClass();
			help["startBtn"].addEventListener(MouseEvent.CLICK, startGame);
			addChild(help);
			
			fg.visible = avatar.visible = beast.visible = false;
			/* ------------------------------------------------------------
			fg["btnExit"].addEventListener(MouseEvent.CLICK, closeCtrl);
			 ------------------------------------------------------------ */
			
			win = new EmbedResource.successClass;
			lose = new EmbedResource.failedClass;
			scene.addChild(lose);
			lose.visible = false;
			
			lose["restartBtn"].addEventListener(MouseEvent.CLICK, restart); 
		}
		
		private function startGame(e:Event):void{
			help["startBtn"].removeEventListener(TimerEvent.TIMER_COMPLETE, startGame);
			help.visible = false;
			
			fg.visible = avatar.visible = beast.visible = true;
			beast.runAfter(avatar);
			sceneSoundCtrl.playSound();
		}
		
		static public function beastHurt():void{
			fg["bossHp"]["bar"]["x"] = (SkeletonBeast.MAX_HP - beast.hp) * (fg["bossHp"]["bar"]["width"]/SkeletonBeast.MAX_HP);
		}
		
		static public function avatarHurt():void{
			fg["avatarHp"].gotoAndStop(6 - avatar.hp); 	
		}
		
		static public function scrollLeft():void{
			if(scene.x < 0)
				scene.x += 10;
		}
		
		static public function scrollRight():void{
			if(scene.x > -(1920 - 960))
				scene.x -= 10;
		}
		
		static public function winGame():void{
			sceneSoundCtrl.stopSound();
			successSoundCtrl.playSound();
			scene.addChild(win);
			win.x = -scene.x;
			//(win as MovieClip).gotoAndPlay(); //.gotoAndPlay(0);
			
			beast.destory();
			avatar.destory();
		}
		
		static public function loseGame():void{
			sceneSoundCtrl.stopSound();
			loseSoundCtrl.playSound();
			lose.visible = true;
			lose.x = -scene.x;
			
			beast.destory();
			avatar.destory();				
			avatar.visible = beast.visible = false;
		}
		
		static public function restart(e:Event):void{
			lose.visible = false;
			
			fg["bossHp"]["bar"]["x"] = 0;
			fg["avatarHp"].gotoAndStop(1); 	
			
			avatar.restart();
			beast.restart();
			avatar.visible = beast.visible = true;
			scene.x = 0;
			
			beast.runAfter(avatar);
			sceneSoundCtrl.playSound()
		}
		
	}
}

