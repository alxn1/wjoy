#import "LoginItemsList.h"

int main (int argc, const char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"%@", [[LoginItemsList userItemsList] allPaths]);
    [pool release];
    return 0;
}
