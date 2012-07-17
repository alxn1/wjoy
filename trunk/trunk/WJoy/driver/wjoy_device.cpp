/*
 *  wjoy_device.cpp
 *  wjoy
 *
 *  Created by alxn1 on 13.07.12.
 *  Copyright 2012 Dr. Web. All rights reserved.
 *
 */

#include "wjoy_device.h"
#include "wjoy_service.h"

WJoyService *WJoyDevice::service()
{
    if(m_Service == 0)
    {
        m_Service = new WJoyService();
        if(!m_Service->open())
        {
            delete m_Service;
            m_Service = 0;
        }
    }

    return m_Service;
}

bool WJoyDevice::isOpened() const
{
    return m_IsOpened;
}

bool WJoyDevice::open(const void *hidDescriptorData, size_t hidDescriptorDataSize)
{
    WJoyService *s = service();
    if(s == 0)
        return false;

    if(!s->call(WJoyService::MethodSelectorEnable, hidDescriptorData, hidDescriptorDataSize))
        return false;

    m_IsOpened = true;
    return true;
}

bool WJoyDevice::updateState(const void *hidData, size_t hidDataSize)
{
    if(!m_IsOpened)
        return false;

    return service()->call(WJoyService::MethodSelectorUpdateState, hidData, hidDataSize);
}

bool WJoyDevice::close()
{
    if(!m_IsOpened)
        return true;

    if(!service()->call(WJoyService::MethodSelectorDisable))
        return false;

    m_IsOpened = false;
    return true;
}

WJoyDevice::WJoyDevice():
    m_Service(0),
    m_IsOpened(false)
{
}

WJoyDevice::~WJoyDevice()
{
    delete m_Service;
}
