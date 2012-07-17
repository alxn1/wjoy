/*
 *  wjoy_service.cpp
 *  wjoy
 *
 *  Created by alxn1 on 13.07.12.
 *  Copyright 2012 Dr. Web. All rights reserved.
 *
 */

#include "wjoy_service.h"

const char WJoyService::deriverName[] = "com_alxn1_driver_WirtualJoy";

io_service_t WJoyService::findService()
{
    io_service_t	result = IO_OBJECT_NULL;
    io_iterator_t 	iterator;

    if(IOServiceGetMatchingServices(
                                 kIOMasterPortDefault,
                                 IOServiceMatching(deriverName),
                                &iterator) != KERN_SUCCESS)
    {
        return result;
    }
    
    result = IOIteratorNext(iterator);
    IOObjectRelease(iterator);
    return result;
}

io_connect_t WJoyService::connect()
{
    io_connect_t result    = IO_OBJECT_NULL;
    io_service_t service   = findService();

    if(service == IO_OBJECT_NULL)
        return result;

    if(IOServiceOpen(service, mach_task_self(), 0, &result) != KERN_SUCCESS)
        result = IO_OBJECT_NULL;

    return result;
}

bool WJoyService::isOpened() const
{
    return (m_DriverConnection != IO_OBJECT_NULL);
}

bool WJoyService::open()
{
    if(isOpened())
        return true;

    m_DriverConnection = connect();
    return isOpened();
}

bool WJoyService::close()
{
    if(!isOpened())
        return true;

    if(IOServiceClose(m_DriverConnection) != KERN_SUCCESS)
        return false;

    m_DriverConnection = IO_OBJECT_NULL;
    return true;
}

bool WJoyService::call(
                    uint32_t selector,
                    const uint64_t *inputValues,
                    uint32_t inputValuesCount,
                    const void *inputBuffer,
                    size_t inputBufferSize,
                    uint64_t *outputValues,
                    uint32_t &outputValuesCount,
                    void *outputBuffer,
                    size_t &outputBufferSize)
{
    if(!isOpened())
        return false;

    return (IOConnectCallMethod(
                         m_DriverConnection,
                         selector,
                         inputValues,
                         inputValuesCount,
                         inputBuffer,
                         inputBufferSize,
                         outputValues,
                        &outputValuesCount,
                         outputBuffer,
                        &outputBufferSize) == KERN_SUCCESS);
                        
}

bool WJoyService::call(
                    uint32_t selector,
                    const void *inputBuffer,
                    size_t inputBufferSize)
{
    uint32_t outputValuesCount = 0;
    size_t outputBufferSize = 0;
    return call(selector, 0, 0, inputBuffer, inputBufferSize, 0, outputValuesCount, 0, outputBufferSize);
}

bool WJoyService::call(uint32_t selector)
{
    return call(selector, 0, 0);
}

WJoyService::WJoyService():
    m_DriverConnection(IO_OBJECT_NULL)
{
}

WJoyService::~WJoyService()
{
    close();
}
