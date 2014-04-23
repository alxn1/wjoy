//
//  WiimotePart.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/WiimoteDeviceReport.h>
#import <Wiimote/WiimoteEventDispatcher.h>
#import <Wiimote/WiimoteIOManager.h>

@interface WiimotePart : NSObject
{
    @private
        Wiimote                 *m_Owner;
        WiimoteEventDispatcher  *m_EventDispatcher;
        WiimoteIOManager        *m_IOManager;
}

+ (void)registerPartClass:(Class)cls;

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager;

- (Wiimote*)owner;
- (WiimoteIOManager*)ioManager;
- (WiimoteEventDispatcher*)eventDispatcher;

- (NSSet*)allowedReportTypeSet;

- (void)connected;
- (void)handleReport:(WiimoteDeviceReport*)report;
- (void)disconnected;

@end
