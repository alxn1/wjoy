#include <IOKit/IOService.h>

#define Test com_alxn1_IOKitTest_TestClass

class Test : public IOService
{
    OSDeclareDefaultStructors(Test)
    public:
        virtual bool init(OSDictionary *dictionary = 0);
        virtual void free();
};
