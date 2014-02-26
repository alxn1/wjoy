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

- (void)notify
{
    static BOOL isInit                                  = NO;
    IOReturn    (*declareUserActivityFn)(
                                    CFStringRef,
                                    IOPMUserActiveType,
                                    IOPMAssertionID*)   = NULL;

    if(!isInit)
    {
		declareUserActivityFn	= dlsym(RTLD_DEFAULT, "IOPMAssertionDeclareUserActivity");
        isInit                  = YES;
    }

    if(declareUserActivityFn != NULL)
        declareUserActivityFn((CFStringRef)@"WJoy controller", kIOPMUserActiveLocal, &m_AssertionID);
    else
        UpdateSystemActivity(UsrActivity);
}

@end
