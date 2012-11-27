//
//  ObjCCallTracer.h
//  ObjCDebug
//
//  Created by alxn1 on 26.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCCallTracer : NSObject
{
    @private
        uint64_t    m_LogEnableFn;
        uint64_t    m_SetLogFnFn;
        BOOL        m_IsEnabled;
}

+ (ObjCCallTracer*)sharedInstance;

@property (nonatomic, readwrite, assign) BOOL enabled;

@end
