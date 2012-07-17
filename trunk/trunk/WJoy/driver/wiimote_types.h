/*
 *  wiimote_types.h
 *  wiipad
 *
 *  Created by Taylor Veltrop on 4/17/08.
 *  Copyright 2008 Taylor Veltrop All rights reserved. 
 *  Portions Copyright 2006 KIMURA Hiroaki. All rights reserved.
 *  Read COPYRIGHT.txt for legal info.
 */

#ifndef wiimotetypes_h
#define wiimotetypes_h

typedef enum {
	WiiRemoteOneButton,
	WiiRemoteTwoButton,
	WiiRemoteAButton,
	WiiRemoteBButton,
	WiiRemoteMinusButton,
	WiiRemoteHomeButton,
	WiiRemotePlusButton,
	WiiRemoteUpButton,
	WiiRemoteDownButton,
	WiiRemoteLeftButton,
	WiiRemoteRightButton,
	
	WiiNunchukZButton,
	WiiNunchukCButton,
	
	WiiClassicControllerYButton, // 14th
	WiiClassicControllerXButton,
	WiiClassicControllerAButton,
	WiiClassicControllerBButton,
	WiiClassicControllerMinusButton,
	WiiClassicControllerHomeButton,
	WiiClassicControllerPlusButton,	
	WiiClassicControllerLeftButton,
	WiiClassicControllerRightButton,
	WiiClassicControllerDownButton,
	WiiClassicControllerUpButton,
	
	WiiClassicControllerLButton,
	WiiClassicControllerRButton,
	WiiClassicControllerZLButton,
	WiiClassicControllerZRButton,	// 15 more
	
	WiiNumberOfButtons
} WiiButtonType;

typedef enum {
	hid_button    = 0,
	hid_XYZ       = WiiNumberOfButtons,
	hid_rXYZ      = WiiNumberOfButtons + 1,
} my_hidElements;

#endif
