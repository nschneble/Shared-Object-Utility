package
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;


	/**
	 * This app simply writes its flashvars to a shared object.
	 */
	public final class Main extends Sprite
	{
		// constants
		public static const SO_NAME : String = "name";
		public static const SO_LOCAL_PATH : String = "/";
		public static const JS_CALLBACK : String = "callback";
		public static const CLEAR_SO : String = "clear_so";


		public function Main ()
		{
			var soName : String = loaderInfo.parameters [SO_NAME];
			var clearSO : Boolean = (loaderInfo.parameters [CLEAR_SO] == "true");

			/*
			 * The app can only proceed if a name is specified for the
			 * shared object.
			 */

			if (soName && soName.length > 0)
			{
				var so : SharedObject = SharedObject.getLocal (soName, SO_LOCAL_PATH);

				if (clearSO)
				{
					// clears all data from the shared object
					so.clear ();
				}
				else
				{
					// writes all flashvars to the shared object
					for (var name : String in loaderInfo.parameters)
					{
						// avoids writing the shared object name, JS callback or clear flag
						if (name != SO_NAME && name != JS_CALLBACK && name != CLEAR_SO)
						{
							so.data [name] = loaderInfo.parameters [name];
						}
					}

					// immediately writes everything to a local file
					so.flush ();
				}
			}

			var jsCallback : String = loaderInfo.parameters [JS_CALLBACK];

			/*
			 * If specified, a JS callback is invoked after the shared
			 * object has been created.
			 */

			if (ExternalInterface.available && jsCallback && jsCallback.length > 0)
			{
				ExternalInterface.call (jsCallback, clearSO);
			}
		}

	}
}
