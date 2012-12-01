package com.saybot.vbpuzzles.challengeBeast.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class SoundCtrl extends EventDispatcher{
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _isCyclePlay:Boolean;
		
		public function SoundCtrl(sound:Sound, isCyclePlay:Boolean = false){
			_sound = sound;
			_isCyclePlay = isCyclePlay;
		}
		
		public function destroy():void{
			if( _soundChannel ){
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, stopSound);
				_soundChannel.stop();
				_soundChannel = null;
			}
		}
		
		public function playSound( e:Event = null ):void{
			if( _soundChannel ){
				_soundChannel.stop();
			}
			_soundChannel = _sound.play();
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, stopSound);
		}
		
		public function stopSound( e:Event = null ):void{
			if( _soundChannel ){
				_soundChannel.stop();
			}
			if(e != null && e.type == Event.SOUND_COMPLETE && _isCyclePlay){
				playSound();
			}
		}
	}
}