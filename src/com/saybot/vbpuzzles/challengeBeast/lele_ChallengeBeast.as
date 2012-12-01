package com.saybot.vbpuzzles.challengeBeast
{
	[SWF(width="960", height="560", nodeRate="30", backgroundColor="#888888")]
	public class lele_ChallengeBeast extends ChallengeBeast
	{
		[Embed(source = "assets/avatar/lele.swf", mimeType="application/octet-stream")]
		public static const avatarClass:Class;
		
		public function lele_ChallengeBeast()
		{
			ChallengeBeast.avatarClass = avatarClass;
			super();
		}
	}
}