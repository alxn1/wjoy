//
//  XibLocalizer.m
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "XibLocalizer.h"
#import "XibObjectInspector.h"

#import "NSString+Escape.h"
#import "NSBundle+NibLoadNotification.h"
#import "LocalizationPreprocessor.h"

NSString *XibLocalizerLocalizableXibsKey = @"LocalizedXibs";

@implementation XibLocalizer

+ (void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [XibLocalizer sharedInstance];
    [pool release];
}

+ (XibLocalizer*)sharedInstance
{
    static XibLocalizer *result = nil;

    if(result == nil)
        result = [[XibLocalizer alloc] init];

    return result;
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Settings = [[NSMutableDictionary alloc] init];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(bundleNibDidLoadNotification:)
                                           name:NSBundleNibDidLoadNotification
                                         object:nil];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(bundleDidLoadNotification:)
                                           name:NSBundleDidLoadNotification
                                         object:nil];

    [self addBundles:[NSBundle allBundles]];
    [self addBundles:[NSBundle allFrameworks]];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_Settings release];
    [super dealloc];
}

- (void)addXib:(NSString*)name
{
    [self addXib:name bundle:[NSBundle mainBundle] stringsFileName:@""];
}

- (void)addXib:(NSString*)name bundle:(NSBundle*)bundle
{
    [self addXib:name bundle:bundle stringsFileName:@""];
}

- (void)addXib:(NSString*)name stringsFileName:(NSString*)stringsFileName
{
    [self addXib:name bundle:[NSBundle mainBundle] stringsFileName:stringsFileName];
}

- (void)addXib:(NSString*)name bundle:(NSBundle*)bundle stringsFileName:(NSString*)stringsFileName
{
    NSMutableDictionary *bundleSettings = [m_Settings objectForKey:[bundle bundlePath]];

    if(bundleSettings == nil)
    {
        bundleSettings = [NSMutableDictionary dictionary];
        [m_Settings setObject:bundleSettings forKey:[bundle bundlePath]];
    }

    [bundleSettings setObject:stringsFileName forKey:name];
}

- (void)addBundle:(NSBundle*)bundle
{
    NSDictionary *dictionary = [[bundle infoDictionary]
                                            objectForKey:XibLocalizerLocalizableXibsKey];

    if(dictionary == nil)
        return;

    [m_Settings setObject:[[dictionary mutableCopy] autorelease]
                   forKey:[bundle bundlePath]];
}

- (void)addBundles:(NSArray*)bundleArray
{
    NSUInteger countBundles = [bundleArray count];

    for(NSUInteger i = 0; i < countBundles; i++)
        [self addBundle:[bundleArray objectAtIndex:i]];
}

- (void)removeXib:(NSString*)name bundle:(NSBundle*)bundle
{
    NSMutableDictionary *bundleSettings = [m_Settings objectForKey:[bundle bundlePath]];

    [bundleSettings removeObjectForKey:name];

    if([bundleSettings count] == 0)
        [m_Settings removeObjectForKey:[bundle bundlePath]];
}

- (void)removeXib:(NSString*)name
{
    [self removeXib:name bundle:[NSBundle mainBundle]];
}

- (void)removeBundle:(NSBundle*)bundle
{
    [m_Settings removeObjectForKey:[bundle bundlePath]];
}

- (NSDictionary*)settings
{
    return [[m_Settings retain] autorelease];
}

- (NSString*)processString:(NSString*)string
                   xibName:(NSString*)xibName
                    bundle:(NSBundle*)bundle
           stringsFileName:(NSString*)stringsFileName
           nonLocalizedSet:(NSMutableSet*)nonLocalizedSet
             isOnlyProcess:(BOOL)isOnlyProcess
{
    if(string == nil || [string length] == 0)
        return @"";

    NSString *result = nil;

    if(!isOnlyProcess)
    {
        result = [bundle localizedStringForKey:string
                                         value:@""
                                         table:stringsFileName];

#ifdef XIB_DUMP_NON_LOCALIZED

        if(result == string)
            [nonLocalizedSet addObject:string];

#endif /* XIB_DUMP_NON_LOCALIZED */
    }
    else
    {
        result = [[LocalizationPreprocessor sharedInstance]
                        preprocessString:string];
    }

    return result;
}

- (void)processObjectProperties:(NSMutableArray*)objectProperties
                        xibName:(NSString*)xibName
                         bundle:(NSBundle*)bundle
                stringsFileName:(NSString*)stringsFileName
                nonLocalizedSet:(NSMutableSet*)nonLocalizedSet
                  isOnlyProcess:(BOOL)isOnlyProcess
{
    NSAutoreleasePool       *pool       = nil;
    XibObjectProperty       *property   = nil;

    while([objectProperties count] > 0)
    {
        pool        = [[NSAutoreleasePool alloc] init];
        property    = [objectProperties objectAtIndex:0];

        [property setValue:[self processString:[property value]
                                       xibName:xibName
                                        bundle:bundle
                               stringsFileName:stringsFileName
                               nonLocalizedSet:nonLocalizedSet
                                 isOnlyProcess:isOnlyProcess]];

        [objectProperties removeObjectAtIndex:0];
        [pool release];
    }
}

- (BOOL)needProcessXib:(NSString*)xibName
                bundle:(NSBundle*)bundle
           rootObjects:(NSArray*)rootObjects
{
    NSDictionary    *bundleSettings     = [m_Settings objectForKey:[bundle bundlePath]];
    NSString        *stringsFileName    = [bundleSettings objectForKey:xibName];

    if(stringsFileName == nil)
    {
        stringsFileName = [bundleSettings objectForKey:
                                [NSString stringWithFormat:@"*%@", xibName]];
    }

    if(bundleSettings == nil)
    {
#ifdef XIB_LOCALIZATION_DEBUG
        NSLog(
            @"[DEBUG] XibLocalizer: skipped xib with name: %@ {%@ (%@)} - "
                @"it's bundle not configured for localization",
            xibName,
            [[bundle bundlePath] lastPathComponent],
            [bundle bundleIdentifier]);
#endif
        return NO;
    }

    if(stringsFileName == nil)
    {
#ifdef XIB_LOCALIZATION_DEBUG
        NSLog(
            @"[DEBUG] XibLocalizer: skipped xib with name: %@ {%@ (%@)} - "
                @"it's not configured for localization",
            xibName,
            [[bundle bundlePath] lastPathComponent],
            [bundle bundleIdentifier]);
#endif
        return NO;
    }

    if([rootObjects count] == 0)
    {
#ifdef XIB_LOCALIZATION_DEBUG
        NSLog(
            @"[DEBUG] XibLocalizer: skipped xib with name: %@ {%@ (%@)} - is empty",
            xibName,
            [[bundle bundlePath] lastPathComponent],
            [bundle bundleIdentifier]);
#endif
        return NO;
    }

    return YES;
}

- (void)dumpNonLocalizedSet:(NSSet*)nonLocalizedSet
                    xibName:(NSString*)xibName
                     bundle:(NSBundle*)bundle
{

#ifdef XIB_DUMP_NON_LOCALIZED

    FILE        *file           = stdout;
    const char  *xibNameUTF8    = [xibName UTF8String];
    const char  *bundleName     = [[[bundle bundlePath] lastPathComponent] UTF8String];
    const char  *bundleID       = [[bundle bundleIdentifier] UTF8String];

#ifdef XIB_DUMP_FILE

    file = fopen(XIB_DUMP_FILE, "ab");

    if(file == NULL)
    {
        NSLog(@"can't open file: %@", @XIB_DUMP_FILE);
        file = stdout;
    }

#endif /* XIB_DUMP_FILE */

    if(file == stdout)
    {
        fprintf(file, "\n--------------------------------------\n");
        fprintf(
            file,
            "Non-localized strings in %s {%s (%s)} xib:\n\n",
            xibNameUTF8, bundleName, bundleID);
    }

    const char *escapedString = NULL;

    for(NSString *str in nonLocalizedSet)
    {
        escapedString = [[str escapedString] UTF8String];
        fprintf(file, "\n/* %s {%s (%s)} */\n", xibNameUTF8, bundleName, bundleID);
        fprintf(file, "\"%s\" = \"%s\";\n", escapedString, escapedString);
    }

    if(file == stdout)
        fprintf(file, "\n--------------------------------------\n\n");
    else
        fclose(file);

#endif /* XIB_DUMP_NON_LOCALIZED */
}

- (void)processXibWithName:(NSString*)xibName
                    bundle:(NSBundle*)bundle
               rootObjects:(NSArray*)rootObjects
{
    if(![self needProcessXib:xibName
                      bundle:bundle
                 rootObjects:rootObjects])
    {
        return;
    }

    NSAutoreleasePool       *pool               = nil;
    NSString                *stringsFileName    = [[m_Settings objectForKey:[bundle bundlePath]] objectForKey:xibName];
    NSMutableArray          *objects            = [NSMutableArray arrayWithArray:rootObjects];
    NSMutableArray          *properties         = [NSMutableArray array];
    NSMutableSet            *processedObjects   = [NSMutableSet set];
    id                       object             = nil;
    NSMutableSet            *nonLocalizedSet    = nil;
    BOOL                     isOnlyProcess      = NO;

    if(stringsFileName == nil)
    {
        stringsFileName = [[m_Settings objectForKey:[bundle bundlePath]]
                                objectForKey:[NSString stringWithFormat:@"*%@", xibName]];

        isOnlyProcess   = YES;
    }

#ifdef XIB_DUMP_NON_LOCALIZED

    nonLocalizedSet = [NSMutableSet set];

#endif /* XIB_DUMP_NON_LOCALIZED */

    if([stringsFileName length] == 0)
        stringsFileName = nil;

    if(bundle == nil)
        bundle = [NSBundle mainBundle];

    while([objects count] != 0)
    {
        pool    = [[NSAutoreleasePool alloc] init];
        object  = [objects objectAtIndex:0];

        if(![processedObjects containsObject:object])
        {
            [XibObjectInspector extractXibObject:object
                                      properties:properties
                                        children:objects];

            [self processObjectProperties:properties
                                  xibName:xibName
                                   bundle:bundle
                          stringsFileName:stringsFileName
                          nonLocalizedSet:nonLocalizedSet
                            isOnlyProcess:isOnlyProcess];

            [processedObjects addObject:object];
        }

        [objects removeObjectAtIndex:0];
        [pool release];
    }

    if(!isOnlyProcess)
    {
        [self dumpNonLocalizedSet:nonLocalizedSet
                          xibName:xibName
                           bundle:bundle];
    }
}

- (void)bundleNibDidLoadNotification:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];

    [self processXibWithName:[info objectForKey:NSBundleNibNameKey]
                      bundle:[info objectForKey:NSBundleNibBundleKey]
                 rootObjects:[info objectForKey:NSBundleNibRootObjectsKey]];
}

- (void)bundleDidLoadNotification:(NSNotification*)notification
{
    [self addBundle:[notification object]];
}

@end
