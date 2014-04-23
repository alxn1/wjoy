//
//  WiimoteEvent.m
//  Wiimote
//
//  Created by alxn1 on 18.01.14.
//

#import "WiimoteEvent.h"

@implementation WiimoteEvent

+ (WiimoteEvent*)eventWithWiimote:(Wiimote*)wiimote
                             path:(NSString*)path
                            value:(CGFloat)value
{
    return [[[WiimoteEvent alloc]
                        initWithWiimote:wiimote
                                   path:path
                                  value:value]
                    autorelease];
}

- (id)initWithWiimote:(Wiimote*)wiimote
                 path:(NSString*)path
                value:(CGFloat)value
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Wiimote           = [wiimote retain];
    m_Path              = [path copy];
    m_PathComponents    = [[m_Path componentsSeparatedByString:@"."] retain];
    m_Value             = value;

    return self;
}

- (void)dealloc
{
    [m_Wiimote release];
    [m_Path release];
    [m_PathComponents release];
    [super dealloc];
}

- (Wiimote*)wiimote
{
    return [[m_Wiimote retain] autorelease];
}

- (NSString*)path
{
    return [[m_Path retain] autorelease];
}

- (NSString*)firstPathComponent
{
    return [m_PathComponents objectAtIndex:0];
}

- (NSString*)lastPathComponent
{
    return [m_PathComponents lastObject];
}

- (NSArray*)pathComponents
{
    return [[m_PathComponents retain] autorelease];
}

- (CGFloat)value
{
    return m_Value;
}

@end
