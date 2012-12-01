package com.saybot.vbpuzzles.challengeBeast
{
	[SWF(width="960", height="560", nodeRate="30", backgroundColor="#888888")]
	public class nani_ChallengeBeast extends ChallengeBeast
	{
		[Embed(source = "assets/avatar/nani.swf", mimeType="application/octet-stream")]
		public static const avatarClass:Class;
		
		public function nani_ChallengeBeast()
		{
			ChallengeBeast.avatarClass = avatarClass;
			super();
		}
	}
}