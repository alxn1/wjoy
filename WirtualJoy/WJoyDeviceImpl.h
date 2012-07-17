//
//  WJoyDeviceImpl.h
//  driver
//
//  Created by alxn1 on 17.07.12.
//  Copyright 2012 Dr. Web. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

typedef enum
{
    WJoyDeviceMethodSelectorEnable        = 0,
    WJoyDeviceMethodSelectorDisable       = 1,
    WJoyDeviceMethodSelectorUpdateState   = 2
} WJoyDeviceMethodSelector;

@interface WJoyDeviceImpl : NSObject
{
    @private
        io_connect_t m_Connection;
}

- (id)init;
- (void)dealloc;

- (BOOL)call:(WJoyDeviceMethodSelector)selector;
- (BOOL)call:(WJoyDeviceMethodSelector)selector data:(NSData*)data;

@end
