package;

import data.*;
import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import input.PlayerSettings;
import lime.app.Application;
import openfl.Lib;
import states.MusicBeatState;
import states.menus.StoryMenuState;
import states.menus.TitleState;
import util.CoolUtil;
import util.Discord.DiscordClient;

class Init extends FlxState
{
	public override function new()
	{
		super();
	}

	public override function create()
	{
		super.create();

		FlxGraphic.defaultPersist = true;

		#if cpp
		cpp.NativeGc.enable(true);
		cpp.NativeGc.run(true);
		#end

		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;

		FlxG.autoPause = false;

		PlayerSettings.reset();

		PlayerSettings.init();

		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;

		#if desktop
		DiscordClient.initialize();
		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end

		Lib.application.window.focus();

		ClientPrefs.loadDefaultKeys();

		Progression.load();

		Paths.excludeAsset('assets/preload/images/kevin_normal.png');
		CoolUtil.precacheImage('kevin_normal', 'preload');

		FlxG.switchState(Type.createInstance(Main.initialState, []));
	}
}