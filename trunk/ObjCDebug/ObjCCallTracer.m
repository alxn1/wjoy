//
//  ObjCCallTracer.m
//  ObjCDebug
//
//  Created by alxn1 on 26.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "ObjCCallTracer.h"

#import "MachOSymbolMap.h"

#import <objc/runtime.h>

#ifdef __LP64__
    #define ADDR_FROM_FN(fn) ((uint64_t)(fn))
    #define FN_FROM_ADDR(addr, fnType) ((fnType)((void*)(addr)))
#else
    #define ADDR_FROM_FN(fn) ((uint64_t)(uint32_t)(fn))
    #define FN_FROM_ADDR(addr, fnType) ((fnType)((void*)((uint32_t)addr)))
#endif

typedef int  (*ObjCTraceFn)(BOOL, const char*, const char*, SEL);
typedef void (*ObjCSetTraceFnFn)(ObjCTraceFn);
typedef void (*ObjCSetTraceEnabledFn)(BOOL);

static int traceFn(
                BOOL           isClassMethod,
                const char    *objectsClass,
                const char    *implementingClass,
                SEL            selector)
{
    if(objectsClass != implementingClass)
    {
        printf(
            "%s [%s (-> %s) %s]\n",
            ((isClassMethod)?("+"):("-")),
            objectsClass,
            implementingClass,
            sel_getName(selector));
    }
    else
    {
        printf(
            "%s [%s %s]\n",
            ((isClassMethod)?("+"):("-")),
            objectsClass,
            sel_getName(selector));
    }

    return 0;
}

@implementation ObjCCallTracer

+ (ObjCCallTracer*)sharedInstance
{
    static ObjCCallTracer *result = nil;

    if(result == nil)
        result = [[ObjCCallTracer alloc] init];

    return result;
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    MachOSymbolMap *map = [MachOSymbolMap loadFromFile:@"/usr/lib/libobjc.dylib"];

    if(map == nil)
    {
        [self release];
        return nil;
    }

    MachOSymbol *getName            = [map findWithName:@"_class_getName"];
    MachOSymbol *msgSends           = [map findWithName:@"_instrumentObjcMessageSends"];
    MachOSymbol *logMsgSend         = [map findWithName:@"_logObjcMessageSends"];

    if(getName                  == nil  ||
       msgSends                 == nil  ||
       logMsgSend               == nil  ||
       getName.info->n_value    == 0    ||
       msgSends.info->n_value   == 0    ||
       logMsgSend.info->n_value == 0)
    {
        [self release];
        return nil;
    }

    uint64_t     getNameAddress     = ADDR_FROM_FN(class_getName);
    uint64_t     msgSendsAddress    = getNameAddress + (msgSends.info->n_value - getName.info->n_value);
    uint64_t     logMsgSendAddress  = getNameAddress + (logMsgSend.info->n_value - getName.info->n_value);

    m_LogEnableFn = msgSendsAddress;
    m_SetLogFnFn  = logMsgSendAddress;

    return self;
}

- (BOOL)enabled
{
    return m_IsEnabled;
}

- (void)setEnabled:(BOOL)flag
{
    if(m_IsEnabled == flag)
        return;

    ObjCSetTraceEnabledFn   enabledFn       = FN_FROM_ADDR(m_LogEnableFn, ObjCSetTraceEnabledFn);
    ObjCSetTraceFnFn        setTraceFnFn    = FN_FROM_ADDR(m_SetLogFnFn, ObjCSetTraceFnFn);

    m_IsEnabled = flag;
    enabledFn(flag);
    setTraceFnFn(((flag)?(traceFn):(NULL)));
}

@end
