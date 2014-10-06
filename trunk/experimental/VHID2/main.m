//
//  main.m
//  VHID2
//
//  Created by Alexander Serkov on 17.03.14.
//  Copyright (c) 2014 Alxn1. All rights reserved.
//

#import <VHID/VHID.h>
#import <WirtualJoy/WJoyDevice.h>

@interface Test : NSObject<VHIDDeviceDelegate>
{
    @private
        NSPoint     m_MousePosition;
        VHIDMouse  *m_MouseState;
        WJoyDevice *m_MouseDevice;
}

+ (void)run;

@end

@implementation Test

+ (void)run
{
    [[[[Test alloc] init] autorelease] run];
}

+ (NSPoint)makePosition:(CGFloat)progress
{
    return NSMakePoint(sin(progress) * 400.0f, cos(progress)  * 400.0f);
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    m_MousePosition = [Test makePosition:0.0f];
    m_MouseState    = [[VHIDMouse alloc] init];
    m_MouseDevice   = [[WJoyDevice alloc]
                            initWithHIDDescriptor:[m_MouseState descriptor]
                                    productString:@"Alxn1 Virtual Mouse"];

    [m_MouseState setDelegate:self];

    return self;
}

- (void)dealloc
{
    [m_MouseState release];
    [m_MouseDevice release];
    [super dealloc];
}

- (void)run
{
    CGFloat progress = 0.0f;

    while(YES)
    {
        NSAutoreleasePool *pool        = [[NSAutoreleasePool alloc] init];
        NSPoint            newPosition = [Test makePosition:progress];

        [m_MouseState updateRelativePosition:
            NSMakePoint(
                newPosition.x - m_MousePosition.x,
                newPosition.y - m_MousePosition.y)];

        m_MousePosition = newPosition;
        progress += 0.01f;

        [[NSRunLoop currentRunLoop]
            runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];

        [pool release];
    }
}

- (void)VHIDDevice:(VHIDDevice*)device stateChanted:(NSData*)state
{
    [m_MouseDevice updateHIDState:state];
}

@end

int main(int argc, const char * argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [Test run];
    [pool release];
    return 0;
}

