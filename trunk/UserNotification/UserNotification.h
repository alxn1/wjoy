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
        NSString     *m_Title;
        NSString     *m_Text;
        NSDictionary *m_UserInfo;
}

+ (UserNotification*)userNotificationWithTitle:(NSString*)title text:(NSString*)text;
+ (UserNotification*)userNotificationWithTitle:(NSString*)title text:(NSString*)text userInfo:(NSDictionary*)userInfo;

- (id)initWithTitle:(NSString*)title text:(NSString*)text userInfo:(NSDictionary*)userInfo;
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
