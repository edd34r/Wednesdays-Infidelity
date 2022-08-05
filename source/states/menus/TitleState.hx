package states.menus;

#if desktop
import sys.thread.Thread;
import util.Discord.DiscordClient;
#end
import data.ClientPrefs;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.Alphabet;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import song.Conductor;

using StringTools;

// import flixel.graphics.FlxGraphic;
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;

	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var mustUpdate:Bool = false;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		// DiscordClient.changePresence("In the Menus", null);

		Main.fpsVar.visible = ClientPrefs.showFPS;

		Main.fpsVar.alpha = 0;

		FlxTween.tween(Main.fpsVar, {alpha: 1}, 1);

		Lib.application.window.title = "Wednesday's Infidelity - Title";

		FlxGraphic.defaultPersist = true;

		curWacky = FlxG.random.getObject(getIntroTextShit());

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var titleTextx:FlxSprite;
	var titleTextxs:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.loopTime = 15920;
				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite(-400, 0).loadGraphic(Paths.image('mickeysangre', 'preload'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.updateHitbox();
		bg.screenCenter(X);
		add(bg);

		titleText = new FlxSprite(-400, -100).loadGraphic(Paths.image('titleEnter'));
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.setGraphicSize(Std.int(titleText.width * 0.55));
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		titleTextx = new FlxSprite(-200, -50).loadGraphic(Paths.image('titleEnter'));
		titleTextx.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleTextx.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleTextx.antialiasing = ClientPrefs.globalAntialiasing;
		titleTextx.setGraphicSize(Std.int(titleText.width * 0.55));
		titleTextx.animation.play('idle');
		titleTextx.updateHitbox();
		add(titleTextx);

		titleTextxs = new FlxSprite(200, 0).loadGraphic(Paths.image('titleEnter'));
		titleTextxs.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleTextxs.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleTextxs.antialiasing = ClientPrefs.globalAntialiasing;
		titleTextxs.setGraphicSize(Std.int(titleTextxs.width * 0.55));
		titleTextxs.animation.play('idle');
		titleTextxs.updateHitbox();
		add(titleTextxs);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.globalAntialiasing;

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.globalAntialiasing;

		// FlxG.camera.shake(0.004, 4000);

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (!transitioning && skippedIntro)
		{
			if (pressedEnter)
			{
				if (titleText != null)
					titleText.animation.play('press');

				if (ClientPrefs.flashing)
					FlxG.camera.flash(FlxColor.BLACK, 2.3, null, true);

				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				titleText.visible = false;
				titleTextx.visible = false;
				titleTextxs.visible = false;

				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					Lib.application.window.title = "Wednesday's Infidelity";
					if (mustUpdate)
					{
						MusicBeatState.switchState(new MainMenuState());
					}
					else
					{
						MusicBeatState.switchState(new MainMenuState());
					}
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
		}

		#if PRIVATE_BUILD
		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}
		#end

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0, ?shake:Bool = false)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet;
			if (shake)
			{
				money = new Alphabet(0, 0, textArray[i], true, false, 0.05, 1, true);
			}
			else
			{
				money = new Alphabet(0, 0, textArray[i], true, false);
			}
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String, ?offset:Float = 0, ?shake:Bool = false)
	{
		if (textGroup != null)
		{
			var coolText:Alphabet;
			if (shake)
			{
				coolText = new Alphabet(0, 0, text, true, false, 0.05, 1, true);
			}
			else
			{
				coolText = new Alphabet(0, 0, text, true, false);
			}
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; // Basically curBeat but won't be skipped if you hold the tab or resize the screen

	private static var closedState:Bool = false;

	override function stepHit()
	{
		super.stepHit();

		if (!closedState)
		{
			switch (curStep)
			{
				case 4:
					createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
				// credTextShit.visible = true;
				case 12:
					addMoreText('present');
				// credTextShit.text += '\npresent...';
				// credTextShit.addText();
				case 16:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = 'In association \nwith';
				// credTextShit.screenCenter();
				case 20:
					createCoolText(['In association', 'with']);
				case 28:
					addMoreText('newgrounds');
					ngSpr.visible = true;
				// credTextShit.text += '\nNewgrounds';
				case 32:
					deleteCoolText();
					ngSpr.visible = false;
				// credTextShit.visible = false;

				// credTextShit.text = 'Shoutouts Tom Fulp';
				// credTextShit.screenCenter();
				case 36:
					addMoreText("The wait is over");
				// credTextShit.visible = true;
				case 44:
					addMoreText("Its finally here");
				// credTextShit.text += '\nlmao';
				case 48:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = "Friday";
				// credTextShit.screenCenter();
				case 52:
					addMoreText('Friday');
				// credTextShit.visible = true;
				case 56:
					addMoreText('Night');
				// credTextShit.text += '\nNight';
				case 60:
					deleteCoolText();
				case 63:
					if (ClientPrefs.shake)
					{
						FlxG.camera.shake(0.004, 99999999999);
					}
					createCoolText([curWacky[0]], 0, true);
				case 74:
					addMoreText(curWacky[1], 0, true);
				case 97:
					deleteCoolText();
				case 108:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			// if (ClientPrefs.flashing)
			FlxG.camera.flash(FlxColor.BLACK, 2.3, null, true);

			remove(credGroup);
			skippedIntro = true;
		}
	}
}
