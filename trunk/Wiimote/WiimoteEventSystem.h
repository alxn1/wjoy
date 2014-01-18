//
//  WiimoteEventSystem.h
//  Wiimote
//
//  Created by Alxn1 on 18.01.14.
//

#import <Wiimote/WiimoteEvent.h>

@interface NSObject (WiimoteEventSystemObserver)

- (void)wiimoteEvent:(WiimoteEvent*)event;

@end

@interface WiimoteEventSystem : NSObject
{
    @private
        NSMutableSet *m_Observers;
}

+ (WiimoteEventSystem*)defaultEventSystem;

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
