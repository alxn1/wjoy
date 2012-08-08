#include "IOKitTest.h"

#define super IOService

OSDefineMetaClassAndStructors(Test, super)

bool Test::init(OSDictionary *dictionary)
{
    if(!super::init(dictionary))
        return false;

    printf("Test class instance created!!!!\n");
    return true;
}

void Test::free()
{
    printf("instance count: %d\n", getMetaClass()->getInstanceCount());
    printf("Test class instance deleted!!!!\n");
    super::free();
}
