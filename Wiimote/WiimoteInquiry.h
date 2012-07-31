//
//  WiimoteInquiry.h
//  Wiimote
//
//  Created by alxn1 on 25.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IOBluetoothDeviceInquiry;

@interface WiimoteInquiry : NSObject
{
    @private
        IOBluetoothDeviceInquiry *m_Inquiry;
        id                        m_Target;
        SEL                       m_Action;
}

+ (BOOL)isBluetoothEnabled;

+ (WiimoteInquiry*)sharedInquiry;

- (BOOL)isStarted;
- (BOOL)startWithTarget:(id)target didEndAction:(SEL)action;
- (BOOL)stop;

@end
