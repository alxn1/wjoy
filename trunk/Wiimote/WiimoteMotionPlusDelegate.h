//
//  WiimoteMotionPlusDelegate.h
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 Dr. Web. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteMotionPlusProtocol

- (WiimoteExtension*)subExtension;
- (void)disconnectSubExtension;

@end

typedef WiimoteExtension<WiimoteMotionPlusProtocol> WiimoteMotionPlusExtension;
