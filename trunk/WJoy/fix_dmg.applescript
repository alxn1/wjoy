#!/usr/bin/osascript

tell application "Finder"
	tell disk "WJoy"
		open
		tell container window
			set current view to icon view
			set toolbar visible to false
			set statusbar visible to false
			set the bounds to {120, 141, 612, 554}
		end tell
		set opts to icon view options of container window
		tell opts
			set arrangement to not arranged
			set shows item info to false
			set icon size to 128
			set text size to 12
		end tell
		set background picture of opts to file ".images:background.png"
		set extension hidden of item "WJoy.app" to true
		set position of item "WJoy.app" to {56 + 64, 231 + 64}
		set position of item "Applications" to {310 + 64, 231 + 64}
		close
		open
		update without registering applications
	end tell
	delay 5
end tell
