/*
 *  wirtual_joy_user_client.cpp
 *  wjoy
 *
 *  Created by alxn1 on 13.07.12.
 *  Copyright 2012 alxn1. All rights reserved.
 *
 */

#include "wirtual_joy.h"
#include "wirtual_joy_user_client.h"
#include "wirtual_joy_device.h"
#include "wirtual_joy_debug.h"

#define super IOUserClient

OSDefineMetaClassAndStructors(WirtualJoyUserClient, super)

const IOExternalMethodDispatch WirtualJoyUserClient::externalMethodDispatchTable[externalMethodCount] =
{
    {
        (IOExternalMethodAction) WirtualJoyUserClient::_enableDevice,
        0, kIOUCVariableStructureSize, 0, 0
    },

    {
        (IOExternalMethodAction) WirtualJoyUserClient::_disableDevice,
        0, 0, 0, 0
    },

    {
        (IOExternalMethodAction) WirtualJoyUserClient::_updateDeviceState,
        0, kIOUCVariableStructureSize, 0, 0
    }
};

IOReturn WirtualJoyUserClient::_enableDevice(WirtualJoyUserClient *target, void *reference, IOExternalMethodArguments *args)
{
    return target->enableDevice(args->structureInput, args->structureInputSize);
}

IOReturn WirtualJoyUserClient::_disableDevice(WirtualJoyUserClient *target, void *reference, IOExternalMethodArguments *args)
{
    return target->disableDevice();
}

IOReturn WirtualJoyUserClient::_updateDeviceState(WirtualJoyUserClient *target, void *reference, IOExternalMethodArguments *args)
{
    return target->updateDeviceState(args->structureInput, args->structureInputSize);
}

bool WirtualJoyUserClient::openOwner(WirtualJoy *owner)
{
    if(owner == 0 || isInactive())
        return false;

    if(!owner->open(this))
        return false;

    m_Owner = owner;
    return true;
}

bool WirtualJoyUserClient::closeOwner()
{
    if(m_Owner != 0)
    {
        if(m_Owner->isOpen(this))
            m_Owner->close(this);

        m_Owner = 0;
    }

    disableDevice();
    return true;
}

bool WirtualJoyUserClient::initWithTask(
                                task_t           owningTask,
                                void            *securityToken,
                                UInt32           type,
                                OSDictionary    *properties)
{
    if(!super::initWithTask(owningTask, securityToken, type, properties))
        return false;

    m_Owner = 0;
    m_Device = 0;
    dmsg("initWithTask");
    return true;
}

bool WirtualJoyUserClient::start(IOService *provider)
{
    WirtualJoy *owner = OSDynamicCast(WirtualJoy, provider);
    if(owner == 0)
        return false;

    if(!super::start(provider))
        return false;

    if(!openOwner(owner))
    {
        super::stop(provider);
        return false;
    }

    dmsgf("start, provider: %p", provider);
    return true;
}

void WirtualJoyUserClient::stop(IOService *provider)
{
    dmsgf("stop, provider: %p", provider);
    closeOwner();
    super::stop(provider);
}

IOReturn WirtualJoyUserClient::clientClose()
{
    dmsg("clientClose");
    closeOwner();
    terminate();
    return kIOReturnSuccess;
}

bool WirtualJoyUserClient::didTerminate(IOService *provider, IOOptionBits options, bool *defer)
{
    dmsg("didTerminate");
    closeOwner();
	*defer = false;
	return super::didTerminate(provider, options, defer);
}

IOReturn WirtualJoyUserClient::externalMethod(
                                    uint32_t selector,
                                    IOExternalMethodArguments *arguments,
									IOExternalMethodDispatch *dispatch,
                                    OSObject *target,
                                    void *reference)
{
    dmsg("externalMehtod");

    if(selector < externalMethodCount)
    {
        dispatch = const_cast< IOExternalMethodDispatch* >(&externalMethodDispatchTable[selector]);
        if(target == 0)
            target = this;
    }
        
	return super::externalMethod(selector, arguments, dispatch, target, reference);
}

IOReturn WirtualJoyUserClient::enableDevice(const void *hidDescriptorData, uint32_t hidDescriptorDataSize)
{
    dmsgf("enableDevice, param size = %d", hidDescriptorDataSize);
    if(m_Device != 0)
    {
        IOReturn result = disableDevice();
        if(result != kIOReturnSuccess)
            return result;
    }

    m_Device = WirtualJoyDevice::withHidDescriptor(hidDescriptorData, hidDescriptorDataSize);
    if(m_Device == 0)
        return kIOReturnDeviceError;

    if(!m_Device->attach(this))
    {
        m_Device->release();
        m_Device = 0;
        return kIOReturnDeviceError;
    }

    if(!m_Device->start(this))
    {
        m_Device->detach(this);
        m_Device->release();
        m_Device = 0;
        return kIOReturnDeviceError;
    }

    return kIOReturnSuccess;
}

IOReturn WirtualJoyUserClient::disableDevice()
{
    dmsg("disableDevice");

    if(m_Device != 0)
    {
        m_Device->terminate(kIOServiceRequired);
        m_Device->release();
        m_Device = 0;
    }

    return kIOReturnSuccess;
}

IOReturn WirtualJoyUserClient::updateDeviceState(const void *hidData, uint32_t hidDataSize)
{
    dmsgf("updateDeviceState, param size = %d", hidDataSize);

    if(m_Device == 0)
        return kIOReturnNoDevice;

    if(!m_Device->updateState(hidData, hidDataSize))
        return kIOReturnDeviceError;

    return kIOReturnSuccess;
}
