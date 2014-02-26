//
//  UserActivityNotifier.h
//  WJoy
//
//  Created by alxn1 on 26.02.14.
//
//

#import <Foundation/Foundation.h>

@interface UserActivityNotifier : NSObject
{
    @private
        NSDate *m_LastNotifyTime;
}

+ (UserActivityNotifier*)sharedNotifier;

- (void)notify;

@end
