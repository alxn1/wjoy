//
//  Wiimote+Tracking.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote+Tracking.h"

@implementation Wiimote (Tracking)

+ (NSMutableArray*)mutableConnectedWiimotes
{
    static NSMutableArray *result = nil;

    if(result == nil)
        result = [[NSMutableArray alloc] init];

    return result;
}

+ (NSArray*)connectedWiimotes
{
    return [self mutableConnectedWiimotes];
}

+ (void)wiimoteConnected:(Wiimote*)wiimote
{
    [[self mutableConnectedWiimotes] addObject:wiimote];
}

+ (void)wiimoteDisconnected:(Wiimote*)wiimote
{
    [[self mutableConnectedWiimotes] removeObject:wiimote];
}

@end
