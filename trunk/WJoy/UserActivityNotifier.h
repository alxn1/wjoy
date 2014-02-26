//
//  UserActivityNotifier.h
//  WJoy
//
//  Created by alxn1 on 26.02.14.
//
//

#import <Foundation/Foundation.h>

#import <IOKit/pwr_mgt/IOPMLib.h>

@interface UserActivityNotifier : NSObject
{
    @private
        IOPMAssertionID  m_AssertionID;
        NSDate          *m_LastNotifyTime;
}

+ (UserActivityNotifier*)sharedNotifier;

- (void)notify;

@end
