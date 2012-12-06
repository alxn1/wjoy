//
//  UAppUpdateChecker.h
//  UpdateChecker
//
//  Created by alxn1 on 17.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <UpdateChecker/UAppVersion.h>

/*

UALatesVersionPlistURL  -> in Info.plist, url
    UAVersion           -> in UALatesVersionPlistURL, string
    UAURL               -> in UALatesVersionPlistURL, string

*/

APPKIT_EXTERN NSString *UAppUpdateCheckerWillStartNotification;
APPKIT_EXTERN NSString *UAppUpdateCheckerDidFinishNotification;

APPKIT_EXTERN NSString *UAppUpdateCheckerHasNewVersionKey;  // NSNumber (BOOL)
APPKIT_EXTERN NSString *UAppUpdateCheckerLatestVersionKey;  // NSString
APPKIT_EXTERN NSString *UAppUpdateCheckerDownloadURLKey;    // NSURL
APPKIT_EXTERN NSString *UAppUpdateCheckerErrorKey;          // NSError

APPKIT_EXTERN NSString *UALatesVersionPlistURLKey;          // UALatesVersionPlistURL

APPKIT_EXTERN NSString *UAVersionKey;                       // UAVersion
APPKIT_EXTERN NSString *UAURLKey;                           // UAURL

@interface UAppUpdateChecker : NSObject
{
    @private
        UAppVersion      m_AppVersion;
        NSString        *m_LatestVersionPlistURL;
        NSURLConnection *m_CurrentConnection;
        NSMutableData   *m_LoadedData;
}

+ (UAppUpdateChecker*)sharedInstance;

- (BOOL)isRun;
- (BOOL)run;

@end
