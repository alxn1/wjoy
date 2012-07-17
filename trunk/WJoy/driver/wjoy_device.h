/*
 *  wjoy_device.h
 *  wjoy
 *
 *  Created by alxn1 on 13.07.12.
 *  Copyright 2012 Dr. Web. All rights reserved.
 *
 */

#ifndef WJOY_DEVICE_H
#define WJOY_DEVICE_H

#include <stdio.h>

class WJoyService;

class WJoyDevice
{
    public:
        bool isOpened() const;
        bool open(const void *hidDescriptorData, size_t hidDescriptorDataSize);
        bool updateState(const void *hidData, size_t hidDataSize);
        bool close();

                 WJoyDevice();
                ~WJoyDevice();

    private:
        WJoyDevice(const WJoyDevice&);
        WJoyDevice &operator = (const WJoyDevice&);

        WJoyService *m_Service;
        bool m_IsOpened;

        WJoyService *service();
};

#endif /* WJOY_DEVICE_H */
