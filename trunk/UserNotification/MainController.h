//
//  MainController.h
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UserNotificationCenterScreenCornerView;

@interface MainController : NSObject
{
    @private
        IBOutlet NSWindow                               *window;
        IBOutlet NSTextField                            *titleTextField;
        IBOutlet NSTextField                            *textTextField;
        IBOutlet NSMatrix                               *notificationSystemMatrix;
        IBOutlet NSButton                               *afterDelayCheckBox;
        IBOutlet NSButton                               *postNotificationButton;
        IBOutlet NSButton                               *soundEnabledCheck;
        IBOutlet UserNotificationCenterScreenCornerView *cornerView;
        IBOutlet NSSlider                               *durationSlider;

        NSTimer                                         *growlAvailableCheckTimer;
}

- (IBAction)showNotification:(id)sender;

@end
