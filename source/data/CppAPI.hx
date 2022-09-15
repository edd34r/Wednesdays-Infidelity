package data;

class CppAPI
{
	#if cpp
	public static function obtainRAM():Int
	{
		return WindowsData.obtainRAM();
	}
	
	#if windows
	public static function darkMode()
	{
		#if windows
		WindowsData.setWindowColorMode(DARK);
		#else
		Main.applyDarkShader();
		#end
	}

	public static function lightMode()
	{
		#if windows
		WindowsData.setWindowColorMode(LIGHT);
		#else
		Main.applyLightShader();
		#end
	}

	public static function setWindowOppacity(a:Float)
	{
		#if windows
		WindowsData.setWindowAlpha(a);
		#else
		Main.setAlpha(a);
		#end
	}

	public static function _setWindowLayered()
	{
		#if windows
		WindowsData._setWindowLayered();
		#end
	}
	#end
	#end
}
