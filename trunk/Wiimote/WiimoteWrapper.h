//
//  WiimoteWrapper.h
//  Wiimote
//
//  Created by alxn1 on 09.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/Wiimote.h>

@class WiimoteWrapper;

@interface NSObject (WiimoteWrapperLog)

- (void)wiimoteWrapper:(WiimoteWrapper*)wrapper log:(NSString*)logLine;

@end

@interface WiimoteWrapper : NSObject
{
    @private
        Wiimote *m_Device;
}

+ (NSObject*)log;
+ (void)setLog:(NSObject*)log;

+ (void)discoveryNew;

@end
