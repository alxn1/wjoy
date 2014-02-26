//
//  UserActivityNotifier.h
//  WJoy
//
//  Created by alxn1 on 26.02.14.
//
//

#import <Foundation/Foundation.h>

#import <IOKit/pwr_mgt/IOPMLib.h>
#import <dlfcn.h>

@interface UserActivityNotifier : NSObject
{
    @private
        IOPMAssertionID m_AssertionID;
}

+ (UserActivityNotifier*)sharedNotifier;

- (void)notify;

@end
