/*
 *  wjoy_service.h
 *  wjoy
 *
 *  Created by alxn1 on 13.07.12.
 *  Copyright 2012 Dr. Web. All rights reserved.
 *
 */

#ifndef WJOY_SERVICE_H
#define WJOY_SERVICE_H

#include <IOKit/IOKitLib.h>

class WJoyService
{
    public:
        enum MethodSelector
        {
            MethodSelectorEnable        = 0,
            MethodSelectorDisable       = 1,
            MethodSelectorUpdateState   = 2
        };

        bool isOpened() const;
        bool open();
        bool close();

        bool call(
                uint32_t selector,
                const uint64_t *inputValues,
                uint32_t inputValuesCount,
                const void *inputBuffer,
                size_t inputBufferSize,
                uint64_t *outputValues,
                uint32_t &outputValuesCount,
                void *outputBuffer,
                size_t &outputBufferSize);

        bool call(
                uint32_t selector,
                const void *inputBuffer,
                size_t inputBufferSize);

        bool call(uint32_t selector);

                 WJoyService();
                ~WJoyService();

    private:
        WJoyService(const WJoyService&);
        WJoyService &operator = (const WJoyService&);

        static const char deriverName[];

        io_connect_t m_DriverConnection;

        static io_service_t findService();
        static io_connect_t connect();
};

#endif /* WJOY_SERVICE_H */
