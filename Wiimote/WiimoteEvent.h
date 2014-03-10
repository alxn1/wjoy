//
//  WiimoteEvent.h
//  Wiimote
//
//  Created by alxn1 on 18.01.14.
//

#import <Wiimote/Wiimote.h>

#define WIIMOTE_EVENT_VALUE_PRESS       1.0
#define WIIMOTE_EVENT_VALUE_RELEASE     0.0

#define WIIMOTE_EVENT_VALUE_CONNECT     WIIMOTE_EVENT_VALUE_PRESS
#define WIIMOTE_EVENT_VALUE_DISCONNECT  WIIMOTE_EVENT_VALUE_RELEASE

@interface WiimoteEvent : NSObject
{
    @private
        Wiimote     *m_Wiimote;
        NSString    *m_Path;
        NSArray     *m_PathComponents;
        CGFloat      m_Value;
}

+ (WiimoteEvent*)eventWithWiimote:(Wiimote*)wiimote
                             path:(NSString*)path
                            value:(CGFloat)value;

- (id)initWithWiimote:(Wiimote*)wiimote
                 path:(NSString*)path
                value:(CGFloat)value;

- (Wiimote*)wiimote;

// path example: @"Connect"
// path example: @"Accelerometer.Pitch"
// path example: @"Classic Controller.Disconnect"
// path example: @"Classic Controller.Button.A"
// path example: @"Classic Controller.Left.Stick.X"
// path example: @"Nunchuck.Stick.Y"

- (NSString*)path;
- (NSString*)firstPathComponent;
- (NSString*)lastPathComponent;
- (NSArray*)pathComponents;

- (CGFloat)value;

@end
