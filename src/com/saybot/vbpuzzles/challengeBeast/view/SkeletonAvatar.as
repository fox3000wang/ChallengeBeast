package com.saybot.vbpuzzles.challengeBeast.view
{
	import akdcl.skeleton.Armature;
	import akdcl.skeleton.BaseCommand;
	import akdcl.skeleton.ConnectionData;
	import akdcl.skeleton.export.ConnectionEncoder;
	import akdcl.skeleton.export.ContourInstaller;
	
	import com.saybot.vbpuzzles.challengeBeast.ChallengeBeast;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SkeletonAvatar extends Sprite
	{
		static public const WHOLE_SCENE_WIDTH:int = 1920;
		static public const SCENE_WIDTH:int       = 960;
		static public const SCENE_HEIGHT:int      = 500;
		static public const SCENE_SPACING:int     = 200;
		
		static public const SPEED_X:int = 10;
		static public const SPEED_Y:int = 18;
		static public const FRAMES_Y:int = 8;
		
		static public const MAX_HP:int = 5;
		
		private var loader:Loader = new Loader();
		private var armature:Armature;
		private var armatureClip:Sprite;
		
		private var left:Boolean;
		private var right:Boolean;
		
		private var isJumping:Boolean = false;
		private var isHurt:Boolean = false;
		private var moveDir:int;
		private var face:int;
		
		private var speedX:Number = 0;
		private var speedY:Number = 0;
		public var hp:int = MAX_HP;
		
		public function SkeletonAvatar()
		{
			super();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadSwfComplateHandler);
			var t:* = ChallengeBeast.avatarClass;
			loader.loadBytes(new ChallengeBeast.avatarClass);
			
			addEventListener(Event.ADDED_TO_STAGE, function():void{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEventHandler);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyEventHandler);	
			});
		}
		
		public function loadSwfComplateHandler(e:Event):void
		{
			var clazz:* = loader.contentLoaderInfo.applicationDomain.getDefinition("avatar");
			var _mc:MovieClip = ContourInstaller.install(new clazz);
			
			var _xml:XML = ConnectionEncoder.encode(_mc);
			ConnectionData.addData(_xml);
			
			var _id:String = "avatar";
			armature = BaseCommand.createArmature(_id, _id, _mc);
			addChild(armature.getDisplay() as Sprite);
			
			armature.animation.playTo("idle", 8, 40, true, 2);
			armatureClip = armature.getDisplay() as Sprite;
			armatureClip.x = 100;
			armatureClip.y = SCENE_HEIGHT;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onKeyEventHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode) {
				case 37 :
				case 65 :
					left = e.type == KeyboardEvent.KEY_DOWN;
					updateMove(-1);
					break;
				case 39 :
				case 68 :
					right = e.type == KeyboardEvent.KEY_DOWN;
					updateMove(1);	
					break;
				case 38 : // up
      			case 32 : // space	
				case 87 :
					if (e.type == KeyboardEvent.KEY_DOWN) {
						jump();
					}
					break;
			}
		}
		
		private function updateMove(_dir:int):void
		{
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
		
		public function move(_dir:int):void
		{
			if (moveDir == _dir) {
				return;
			}
			face = moveDir = _dir;
			updateMovement();
		}
		
		public function jump(force:Boolean = false, light:Boolean = false):void
		{
			if (isJumping && !force)
				return;
			
			if(light){
				speedY = -(SPEED_Y/2);	
			}else{
				speedY = -SPEED_Y;
			}
			isJumping = true;
			armature.animation.playTo("jump", FRAMES_Y);
		}
		
		public function hurt():void
		{
			if(isHurt)
				return;	
			
			hp--;
			ChallengeBeast.avatarHurt();
			if(hp > 0){
				isHurt = true;
				updateMovement();

				armatureClip.alpha = 0.5;
				armatureClip.x += (ChallengeBeast.beast.face * 100);
				fixPosition();
				
				var timer:Timer = new Timer(2000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{
					isHurt = false;
					armatureClip.alpha = 1;
					updateMovement();
				});
				timer.start();	
			}else{
				die();
			}
		}
			
		public function die():void
		{
			ChallengeBeast.loseGame();
		}
		
		public function restart():void
		{
			hp = MAX_HP;
			armatureClip.x = 100;
			armatureClip.y = SCENE_HEIGHT;
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function updateMovement():void
		{
			if (isJumping)
				return;
			
			if (moveDir == 0) {
				speedX = 0;
				armature.animation.playTo("idle", 8, 40, true, 2);
			}else {
				speedX = face * SPEED_X ;
				armature.animation.playTo("run", 4, 12, true, 2);	
			}
		} 
		
		
		private function updateSpeed():void
		{
			if(isJumping) {
				if (speedY <= 0 && speedY + 1 > 0 ) {
					armature.animation.playTo("fall", FRAMES_Y);
				}
				speedY += 1;
			}
			if(speedY >=0 && walkAble == -1){
				armature.animation.playTo("fall", FRAMES_Y);
				speedY += 1;
				isJumping = true;
			}
			if(speedX == 0 && !isJumping && isSlide){
				armatureClip.x += SPEED_X * armatureClip.scaleX;
				fixPosition();
			}
			if(speedX != 0) {
				armatureClip.x += speedX;
				fixPosition();
			}
			if(speedY > 0 && touchRock){
				jump(true,true); 
				return;
			}
			if (speedY != 0) {
				armatureClip.y += speedY;
				if((walkAble != -1 && speedY > 0) || armatureClip.y > SCENE_HEIGHT){
					armatureClip.y = walkAble; 
					isJumping = false;
					speedY = 0;
					updateMovement();
				}
			}
			
		}
		
		private function get walkAble():Number
		{
			for(var i:int = 0; i < ChallengeBeast.walkArea.length; i++){
				var area:Object = ChallengeBeast.walkArea[i];
				if(armatureClip.x > area["xFrom"] && armatureClip.x < area["xTo"] 
					&& armatureClip.y > area["y"] && armatureClip.y < area["y"]+40){
					return area["y"] + 20;
				}
			}
			return -1;
		}
		
		private function get touchRock():Boolean
		{
			for(var i:int = 0; i < ChallengeBeast.rockArea.length; i++){
				var area:Object = ChallengeBeast.rockArea[i];
				if(armatureClip.x > area["xFrom"] && armatureClip.x < area["xTo"] 
					&& armatureClip.y > area["y"]-10 && armatureClip.y < area["y"]+20){
					var rock:Rock = area["view"] as Rock;
					if(rock.active){
						rock.kick();
						return true;
					}
				}
			}
			return false;
		}
		
		private function updateFace():void {
			if (armatureClip.scaleX != face && face != 0) {
				armatureClip.scaleX = face;
				updateMovement();
			}
		}
		
		private function scrollScene():void {
			if(armatureClip.x + ChallengeBeast.scene.x  >= SCENE_WIDTH - SCENE_SPACING )
				ChallengeBeast.scrollRight();
			
			if(armatureClip.x + ChallengeBeast.scene.x  <= SCENE_SPACING )
				ChallengeBeast.scrollLeft();
		}
		
		private function onEnterFrameHandler(e:Event):void {
			scrollScene();
			updateSpeed();
			updateFace();
			armature.update();
		}
		
		private function fixPosition():void{
			if (armatureClip.x <= 20) {
				armatureClip.x = 20;
			}else if (armatureClip.x > WHOLE_SCENE_WIDTH-20) {
				armatureClip.x = WHOLE_SCENE_WIDTH-20;
			}
		}
		
		private function get isSlide():Boolean{
			return armatureClip.y < 250;
		}
		
		public function get view():Sprite{
			return armatureClip;
		}
		
		public function destory():void{
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
	}
}
