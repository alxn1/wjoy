//
//  WiimoteAnalogNormalizer.h
//  Wiimote
//
//  Created by alxn1 on 21.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *WiimoteNormalizerPropertyMinKey;
FOUNDATION_EXPORT NSString *WiimoteNormalizerPropertyMaxKey;
FOUNDATION_EXPORT NSString *WiimoteNormalizerPropertyCenterKey;
FOUNDATION_EXPORT NSString *WiimoteNormalizerPropertyDeadZoneKey;

typedef enum
{
    WiimoteAnalogNormalizerTypeStick,
    WiimoteAnalogNormalizerTypeShift,
    WiimoteAnalogNormalizerTypeUnknown
} WiimoteAnalogNormalizerType;

@interface WiimoteAnalogNormalizer : NSObject<NSCoding>
{
    @private
        NSMutableDictionary *m_Properties;
}

+ (id)stickNormalizer;
+ (id)shiftNormalizer;

- (NSDictionary*)properties;
- (NSValue*)propertyValueForKey:(NSString*)key;

- (NSValue*)normalize:(NSValue*)value;

- (WiimoteAnalogNormalizerType)type;

@end

@interface WiimoteMutableAnalogNormalizer : WiimoteAnalogNormalizer

- (BOOL)setPropertyValue:(NSValue*)value forKey:(NSString*)key;
- (void)resetPropertyValueForKey:(NSString*)key;

@end
