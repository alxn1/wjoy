//
//  UserActivityNotifier.m
//  WJoy
//
//  Created by alxn1 on 26.02.14.
//
//

#import "UserActivityNotifier.h"

@implementation UserActivityNotifier

+ (UserActivityNotifier*)sharedNotifier
{
    static UserActivityNotifier *result = nil;

    if(result == nil)
        result = [[UserActivityNotifier alloc] init];

    return result;
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    m_LastNotifyTime = [[NSDate alloc] init];
    return self;
}

- (void)dealloc
{
    [m_LastNotifyTime release];
    [super dealloc];
}

- (void)notify
{
    NSDate *now = [NSDate date];

    if([now timeIntervalSinceDate:m_LastNotifyTime] >= 5.0)
    {
        UpdateSystemActivity(UsrActivity);

        [m_LastNotifyTime release];
        m_LastNotifyTime = [now retain];
    }
}

@end
