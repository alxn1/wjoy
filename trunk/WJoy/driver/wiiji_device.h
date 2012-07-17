/*
 *  wiiji_device.h
 *  wjoy
 *
 *  Created by alxn1 on 13.07.12.
 *  Copyright 2012 Dr. Web. All rights reserved.
 *
 */

#ifndef WIIJI_DEVICE_H
#define WIIJI_DEVICE_H

#include "wjoy_device.h"

class WiijiDevice
{
    public:
        bool open();
        bool update(const void *state, size_t stateSize);
        bool close();

                 WiijiDevice();

    private:
        WiijiDevice(const WiijiDevice&);
        WiijiDevice &operator = (const WiijiDevice&);

        static const unsigned char  hidDescriptorData[];
        static const size_t         hidStateDataSize = 6;

        WJoyDevice m_Device;
        unsigned char m_HIDStateData[hidStateDataSize];
};

#endif /* WIIJI_DEVICE_H */
