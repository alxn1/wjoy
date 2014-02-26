//
//  UserActivityNotifier.m
//  WJoy
//
//  Created by alxn1 on 26.02.14.
//
//

#import "UserActivityNotifier.h"

#import <dlfcn.h>

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

- (void)updateSystemActivity
{
    typedef IOReturn (*DeclareUserActivityFn)(CFStringRef, IOPMUserActiveType, IOPMAssertionID*);

    static BOOL                     isInit              = NO;
    static DeclareUserActivityFn    declareUserActivity = NULL;
    static CFStringRef              activityName        = (CFStringRef)@"WJoy Controller";

    if(!isInit)
    {
		declareUserActivity	= dlsym(RTLD_DEFAULT, "IOPMAssertionDeclareUserActivity");
        isInit              = YES;
    }

    if(declareUserActivity != NULL)
        declareUserActivity(activityName, kIOPMUserActiveLocal, &m_AssertionID);
    else
        UpdateSystemActivity(UsrActivity);
}

- (void)notify
{
    NSDate *now = [NSDate date];

    if([now timeIntervalSinceDate:m_LastNotifyTime] >= 30.0)
    {
        [self updateSystemActivity];

        [m_LastNotifyTime release];
        m_LastNotifyTime = [now retain];
    }
}

@end
