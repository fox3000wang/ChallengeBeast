package com.saybot.vbpuzzles.challengeBeast.view
{
	import akdcl.skeleton.Armature;
	import akdcl.skeleton.BaseCommand;
	import akdcl.skeleton.ConnectionData;
	import akdcl.skeleton.export.ConnectionEncoder;
	import akdcl.skeleton.export.ContourInstaller;
	
	import com.saybot.vbpuzzles.challengeBeast.ChallengeBeast;
	import com.saybot.vbpuzzles.challengeBeast.EmbedResource;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SkeletonBeast extends Sprite
	{
		static public const SPEED_X:int = 5;
		static public const MAX_HP:int = 5;
		
		private var loader:Loader = new Loader();
		private var armature:Armature;
		private var armatureClip:Sprite;
		private var armatureDie:Armature;
		private var armatureDieClip:Sprite;
		
		private var left:Boolean;
		private var right:Boolean;
		
		private var moveDir:int;
		public var face:int;
		
		public var hp:int = MAX_HP;
		private var speedX:Number = 0;
		private var isHurt:Boolean = false;
		private var isAttack:Boolean = false;
		
		private var timer:Timer;
		private var target:Sprite;
		
		public function SkeletonBeast()
		{
			super();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSwfComplateHandler);
			loader.loadBytes(new EmbedResource.beastClass);
		}
		
		public function loadSwfComplateHandler(e:Event):void{
			
			var clazz:* = loader.contentLoaderInfo.applicationDomain.getDefinition("beast");
			var _mc:MovieClip = ContourInstaller.install(new clazz);
			var _xml:XML = ConnectionEncoder.encode(_mc);
			ConnectionData.addData(_xml);
			
			var _id:String = "beast";
			armature = BaseCommand.createArmature(_id, _id, _mc);
			addChild(armature.getDisplay() as Sprite);
			
			armature.animation.playTo("idle", 8, 40, true, 2);
			armatureClip = armature.getDisplay() as Sprite;
			armatureClip.x = 900;
			armatureClip.y = 500;
			
			clazz = loader.contentLoaderInfo.applicationDomain.getDefinition("beastdie");
			_mc = ContourInstaller.install(new clazz);
			_xml = ConnectionEncoder.encode(_mc);
			armatureDie = BaseCommand.createArmature(_id, _id, _mc);
			armatureDieClip = armatureDie.getDisplay() as Sprite; 
			addChild(armatureDieClip);
			armatureDieClip.visible =false;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		public function runAfter(avatar:SkeletonAvatar):void{
			target = avatar.view;
			addEventListener(Event.ENTER_FRAME, runAi);
		}
		
		private function runAi(e:Event):void{
			if(isAttack)
				return;
			
			if(isInRange){
				isAttack = true;
				updateMovement();
				
				var timer:Timer = new Timer(500,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{
					isAttack = false;
					ChallengeBeast.bossAttackSoundCtrl.playSound();
					updateMovement();
					if(isInRange){
						ChallengeBeast.avatar.hurt();						
					}
				});
				timer.start();	
			}
			
			if(Math.abs(target.x - armatureClip.x) < 140){
				move(0);
				if(target.x > armatureClip.x){
					face = 1;
				}else{
					face = -1;
				}	
				return;
			}
			
			if(target.x > armatureClip.x){
				move(1);
			}else{
				move(-1);
			}
		}
		
		private function get isInRange():Boolean{
			return Math.abs(target.x - armatureClip.x) < 150 &&
				Math.abs(target.y - armatureClip.y) < 160;
		}
		
		private function updateMove(_dir:int):void {
			if (left && right) {
				move(_dir);
			}else if (left){
				move(-1);
			}else if (right){
				move(1);
			}else {
				move(0);
			}
		}
		
		public function move(_dir:int):void {
			if (moveDir == _dir) {
				return;
			}
			face = moveDir = _dir;
			updateMovement();
		}
		
		public function hurt():void {
			hp--;
			ChallengeBeast.beastHurt();
			if(hp > 0){
				isHurt = true;
				updateMovement();
				
				var timer:Timer = new Timer(1000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{
					isHurt = false;
					updateMovement();
				});
				timer.start();	
			}else{
				die();
			}
		}
		
		public function die():void {
			speedX = 0;
			armatureClip.visible = false;
			armatureDieClip.visible = true;
			armatureDieClip.x = armatureClip.x;
			armatureDieClip.y = armatureClip.y;
			armatureDieClip.scaleX = armatureClip.scaleX;
			armatureDie.animation.playTo("die", 30, 100, false, 2);
			removeEventListener(Event.ENTER_FRAME, runAi);
			ChallengeBeast.winGame();
			/* ------------------------------------------------------------------------------------
			var timeer:Timer = new Timer(5000,1);
			timeer.addEventListener(TimerEvent.TIMER_COMPLETE, ChallengeBeast.INSTANCE.returnCtrl);
			timeer.start();
			------------------------------------------------------------------------------------- */
		}
		
		public function restart():void {
			hp = MAX_HP;
			armatureClip.visible = true;
			armatureDieClip.visible = false;
			armatureClip.x = 900;
			armatureClip.y = 500;
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
	
		private function updateMovement():void {
			if(hp <= 0){
				return;
			}
			
			if(isHurt){
				speedX = 0;
				armature.animation.playTo("hurt", 2, 2, false, 2);
				return;
			}
			
			if(isAttack){
				speedX = 0;
				if(target.y < 400){
					armature.animation.playTo("attack1", 4, 4, false, 2);
				}else{
					armature.animation.playTo("attack2", 4, 4, false, 2);	
				}
				return;
			}
			
			if (moveDir == 0) {
				speedX = 0;
				armature.animation.playTo("idle", 8, 40, true, 2);
			}else {
				speedX = face * SPEED_X ;
				armature.animation.playTo("run", 8, 24, true, 2);
			}
		}
		
		private function updateSpeed():void {
			if (speedX != 0) {
				armatureClip.x += speedX;
				if (armatureClip.x < 0) {
					armatureClip.x = 0;
				}else if (armatureClip.x > SkeletonAvatar.WHOLE_SCENE_WIDTH) {
					armatureClip.x = SkeletonAvatar.WHOLE_SCENE_WIDTH;
				}
			}
		}
		
		private function updateFace():void {
			if (armatureClip.scaleX != face && face != 0) {
				armatureClip.scaleX = face;
				updateMovement();
			}
		}
		
		private function onEnterFrameHandler(e:Event):void {
			updateSpeed();
			updateFace();
			armature.update();
		}
		
		public function get view():Sprite{
			return armatureClip;
		}
		
		public function destory():void{
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			removeEventListener(Event.ENTER_FRAME, runAi);
		}
		
	}
}