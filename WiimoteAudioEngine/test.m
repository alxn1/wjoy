//
//  test.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WiimoteAudioEngine.h"

int main(int argC, char *argV[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"!!!");
    [WiimoteAudioEngine test];
    [pool release];
    return 0;
}
