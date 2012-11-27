//
//  main.m
//  ObjCDebug
//
//  Created by alxn1 on 27.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjCDebug/ObjCCallTracer.h>

int main(int argC, char *argV[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [ObjCCallTracer sharedInstance].enabled = YES;
    NSLog(@"%@", [@"some string" stringByAppendingFormat:@" %i", 120]);
    [ObjCCallTracer sharedInstance].enabled = NO;

    [pool drain];
    return 0;
}
