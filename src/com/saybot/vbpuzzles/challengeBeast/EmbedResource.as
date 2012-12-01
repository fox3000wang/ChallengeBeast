package com.saybot.vbpuzzles.challengeBeast
{
	public class EmbedResource
	{
		
		[Embed(source = "chapter01/scene.swf", symbol="scene")]
		public static const sceneClass:Class;

		[Embed(source = "chapter01/help.swf", symbol="help")]
		public static const helpClass:Class;
		
		[Embed(source = "chapter01/beast.swf", mimeType="application/octet-stream")]
		public static const beastClass:Class;
		
		[Embed(source = "chapter01/failed.swf", symbol="failed")]
		public static const failedClass:Class;
		
		[Embed(source = "chapter01/success.swf", symbol="success")]
		public static const successClass:Class;
		

		
		[Embed(source = "chapter01/sound.swf", symbol="scene_sound")]
		public static const sceneMusicClass:Class;
		
		[Embed(source = "chapter01/sound.swf", symbol="success_sound")]
		public static const successMusicClass:Class;
		
		[Embed(source = "chapter01/sound.swf",symbol="lose_sound")]
		public static const loseMusicClass:Class;
		
		[Embed(source = "chapter01/sound.swf", symbol="stone_sound")]
		public static const stoneSoundClass:Class;
		
		[Embed(source = "chapter01/sound.swf", symbol="bossattack_sound")]
		public static const bossAttackSoundClass:Class;

	}
}