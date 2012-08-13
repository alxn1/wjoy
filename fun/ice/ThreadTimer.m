//
//  ThreadTimer.m
//  ice
//
//  Created by alxn1 on 29.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "ThreadTimer.h"

@implementation ThreadTimer

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithTarget:(id)target
              action:(SEL)action
            interval:(double)interval
{
    self = [super init];
    if( self == nil )
        return nil;

    m_Target    = target;
    m_Action    = action;
    m_Interval  = interval;

    m_NeedStop  = NO;
    m_IsStopped = YES;

    return self;
}

- (void)dealloc
{
    [self stop];
    [super dealloc];
}

- (void)start
{
    @synchronized(self)
    {
        if(!m_IsStopped)
            return;
    }

    [NSThread detachNewThreadSelector:@selector(thread)
                             toTarget:self
                           withObject:nil];
}

- (void)stop
{
    @synchronized(self)
    {
        m_NeedStop = YES;
    }

    while(YES)
    {
        @synchronized(self)
        {
            if(m_IsStopped)
                break;
        }

        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        [pool release];
    }
}

- (void)thread
{
    while(YES)
    {
        @synchronized(self)
        {
            if(m_NeedStop)
                break;
        }

        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:m_Interval]];
        [m_Target performSelectorOnMainThread:m_Action withObject:nil waitUntilDone:YES];
        [pool release];
    }

    @synchronized(self)
    {
        m_IsStopped = YES;
    }
}

@end
