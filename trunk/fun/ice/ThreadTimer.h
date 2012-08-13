//
//  ThreadTimer.h
//  ice
//
//  Created by alxn1 on 29.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ThreadTimer : NSObject
{
    @private
        id      m_Target;
        SEL     m_Action;
        double  m_Interval;

        BOOL    m_NeedStop;
        BOOL    m_IsStopped;
}

- (id)initWithTarget:(id)target
              action:(SEL)action
            interval:(double)interval;

- (void)start;
- (void)stop;

@end
