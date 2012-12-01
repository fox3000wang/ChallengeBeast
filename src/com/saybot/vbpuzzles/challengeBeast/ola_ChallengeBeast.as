package com.saybot.vbpuzzles.challengeBeast
{
	[SWF(width="960", height="560", nodeRate="30", backgroundColor="#888888")]
	public class ola_ChallengeBeast extends ChallengeBeast
	{
		[Embed(source = "avatar/ola.swf", mimeType="application/octet-stream")]
		public static const avatarClass:Class;
		
		public function ola_ChallengeBeast()
		{
			ChallengeBeast.avatarClass = avatarClass;
			super();
		}
	}
}