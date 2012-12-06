//
//  NSObject+ObjCRuntime.m
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSObject+ObjCRuntime.h"

@implementation NSObject (ObjCRuntime)

+ (Method)getMethod:(SEL)name
{
    return class_getInstanceMethod(self, name);
}

+ (Method)getClassMethod:(SEL)name
{
    return class_getClassMethod(self, name);
}

+ (BOOL)addMethod:(Method)method name:(SEL)name
{
    IMP imp = method_getImplementation(method);

    if(imp == NULL)
        return NO;

    return class_addMethod(self, name, imp, method_getTypeEncoding(method));
}

+ (BOOL)addClassMethod:(Method)method name:(SEL)name
{
    return [object_getClass(self) addMethod:method name:name];
}

+ (BOOL)swizzleMethod:(SEL)originalName withMethod:(SEL)newName
{
    Method originalMethod   = class_getInstanceMethod(self, originalName);
    Method newMethod        = class_getInstanceMethod(self, newName);

    if(originalMethod   == NULL ||
       newMethod        == NULL)
    {
        return NO;
    }
	
	class_addMethod(self,
					originalName,
					class_getMethodImplementation(self, originalName),
					method_getTypeEncoding(originalMethod));

	class_addMethod(self,
					newName,
					class_getMethodImplementation(self, newName),
					method_getTypeEncoding(newMethod));
	
	method_exchangeImplementations(
                    class_getInstanceMethod(self, originalName),
                    class_getInstanceMethod(self, newName));

	return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalName withMethod:(SEL)newName
{
    return [object_getClass(self) swizzleMethod:originalName withMethod:newName];
}

@end
