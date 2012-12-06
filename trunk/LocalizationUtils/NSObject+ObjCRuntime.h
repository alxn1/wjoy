//
//  NSObject+ObjCRuntime.h
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <objc/objc-class.h>

@interface NSObject (ObjCRuntime)

+ (Method)getMethod:(SEL)name;
+ (Method)getClassMethod:(SEL)name;

+ (BOOL)addMethod:(Method)method name:(SEL)name;
+ (BOOL)addClassMethod:(Method)method name:(SEL)name;

+ (BOOL)swizzleMethod:(SEL)originalName withMethod:(SEL)newName;
+ (BOOL)swizzleClassMethod:(SEL)originalName withMethod:(SEL)newName;

@end
