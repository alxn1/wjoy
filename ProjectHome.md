Nintendo wiimote driver for Mac OS X. Including virtual HID interface driver (can be used for creating virtual mouses, keyboars, joysticks) and user-space software for interaction with wiimotes.

You can donate some money (if you wish) to me (and WJoy :) ):

https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=K9LWNA6E5RS28

alxn1(dot)yandex(dot)ru - it's my other email, don't fear. But please, if you want write to me - write to gmail :)

Latest version: 0.7.1
> http://code.google.com/p/wjoy/downloads/detail?name=wjoy%200.7.1.dmg

For OS X 10.10, if after upgrade WJoy stop work:

  1. remove WJoy (and remove it from trash)
  1. remove all Wiimotes from system bluetooth settings
  1. install WJoy (from dmg)
  1. start it
  1. select "One Button Click Option"
  1. try connect wiimotes

Crash (on Wiimote disconnections) i'll fix later.

For mapping Wiimote buttons to keyboard, you can use this utilities:

  1. http://justintime4java.weebly.com/wiicontroll.html - WiiControll (Justin Wong)
  1. http://abstractable.net/enjoy/ - Enjoy (Sam McCall)

One-Button-Click-Connection option: enable this option, and for the first time try to connect Wiimote or Wii U Pro Controller with old method (1 + 2 buttons or red sync button). After what, WJoy (and OS X) will remember this device, and if you press any button on disconnected controller, it's connect to your mac and WJoy (if it started).

WARNING!!! If you Wii Remote connect to WJoy, and device disconnect immediatelly - use sync button (http://wiibrew.org/wiki/Wiimote#Bluetooth_Communication). Thansk to Miguel Pontes for this hint. :)

WARNING2!!! On 10.5, if after WJoy connecting to wiimote all system are freezes, try to reboot computer, and after rebooting: select WJoy in Finder, open context menu, select item "Get Info", and set "Open in 32 Bit Mode". It's bug in bluetooth stack in 10.5 - 64-bit applications can't use bluetooth.

PS: Dock2D.app: https://drive.google.com/file/d/0B9g71PXQQjBiemlGdzk4amRKNVU - simple utility, what transform Dock to 2D in OS X 10.9 Maveriks. Can be added to autostart (in System Preferences, Users and Groups, Login Items).

New in version 0.7.1:
  1. fixes for new OS X 10.9
  1. added new One-Button-Click-Connection
  1. other fixes :)

New in version 0.7:
  1. now WJoy have dmg
  1. added support of Wii U Pro Controller
  1. small fixes/workaround for some games
  1. now L and R analogs of Classic Controller mapped to stick
  1. ice.app now support retina display
  1. small other fixes :)

New in version 0.6:
  1. added ability to check new version
  1. fixed crash, if wiimote connected and then disconnected immediately
  1. added additional checking of wrong calibration data for Classic Controller Pro (unofficial)
  1. added new unofficial nunchuck identificators
  1. small other fixes

New in version 0.5.1:
  1. Fixed some small memory leaks in kernel extension and WJoy
  1. now icon in menu bar visible on 10.5
  1. added support of Classic Controller Pro (thanks to reidab :) ).

New in version 0.5:
  1. Fixed pairing error on Mac OS X 10.8.2
  1. Added full support of MotionPlus in Wiimote.framework (but it's currently not used in WJoy - maybe later)
  1. Fixed some other small bugs.

PS: WJoy in softpedia: http://mac.softpedia.com/get/Games/WJoy.shtml :)