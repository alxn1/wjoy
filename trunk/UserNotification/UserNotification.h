//
//  UserNotification.h
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UserNotification : NSObject<NSCoding>
{
    @private
        NSString     *title;
        NSString     *text;
        NSDictionary *userInfo;
}

+ (UserNotification*)userNotificationWithTitle:(NSString*)aTitle text:(NSString*)aText;
+ (UserNotification*)userNotificationWithTitle:(NSString*)aTitle text:(NSString*)aText userInfo:(NSDictionary*)aUserInfo;

- (id)initWithTitle:(NSString*)aTitle text:(NSString*)aText userInfo:(NSDictionary*)aUserInfo;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)initWithCoder:(NSCoder*)decoder;
- (void)dealloc;

- (NSString*)title;
- (NSString*)text;
- (NSDictionary*)userInfo;

- (void)encodeWithCoder:(NSCoder*)coder;
- (NSDictionary*)asDictionary;
- (NSString*)description;

@end
