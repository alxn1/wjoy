//
//  NSBundle+NibLoadNotification.h
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

APPKIT_EXTERN NSString *NSBundleNibDidLoadNotification;

APPKIT_EXTERN NSString *NSBundleNibNameKey;         // NSString
APPKIT_EXTERN NSString *NSBundleNibOwnerKey;        // id, optional
APPKIT_EXTERN NSString *NSBundleNibBundleKey;       // NSBundle, optional
APPKIT_EXTERN NSString *NSBundleNibFilePathKey;     // NSString
APPKIT_EXTERN NSString *NSBundleNibRootObjectsKey;  // NSArray of id
