#import "DMGEULAResource+DMG.h"
#import "DMGEULAResource+DeepStore.h"
#import "DMGEULAPathPreprocessor.h"

int main(int argC, char *argV[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if(argC < 2)
    {
        printf("USAGE: %s [-licenses_dir <path>] [-dmg_path <path>] [-dump_r] -lang_plist_path <path>\n", argV[0]);
        printf("\t-licenses_dir     - path to lecenses *.rtf files (default - current directory)\n");
        printf("\t-dmg_path         - path to dmg to patch (can be empty, if dump_rc option exist)\n");
        printf("\t-dump_rc          - only dump *.r file to stdout\n");
        printf("\t-lang_plist_path  - path to .plist with all localizations and preferences.\n");
        printf("\n");
        printf("In .plist you can use {%%LICENSE_DIR%%} variable for path to rtf files\n");
        printf("LanguageCode - is are verUS/verRussia/other ver* constants\n");
        printf("Encoding - is are CFStringEncoding constant\n");
        printf("\n");
        [pool drain];
        return 0;
    }
    
    NSString *licesesDir    = [[NSUserDefaults standardUserDefaults] stringForKey:@"licenses_dir"];
    NSString *plistPath     = [[NSUserDefaults standardUserDefaults] stringForKey:@"lang_plist_path"];
    NSString *dmgPath       = [[NSUserDefaults standardUserDefaults] stringForKey:@"dmg_path"];
    BOOL      dumpRC        = [[NSUserDefaults standardUserDefaults] boolForKey:@"dump_r"];

    if(plistPath == nil)
    {
        printf("Languages .plist file not specified, abort\n");
        [pool drain];
        return 1;
    }

    if(dmgPath == nil && !dumpRC)
    {
        printf("Path to .dmg file not specified, abort\n");
        [pool drain];
        return 1;
    }

    if(licesesDir == nil)
        licesesDir = [[NSFileManager defaultManager] currentDirectoryPath];

    [[DMGEULAPathPreprocessor sharedInstance] setVariable:@"LICENSE_DIR" value:licesesDir];

    DMGEULAResource *resource = [DMGEULAResource fromDeepPList:[NSData dataWithContentsOfFile:plistPath] error:NULL];

    if(resource == nil)
    {
        printf("Can't load .plist file: %s, aborted\n", [plistPath UTF8String]);
        [pool drain];
        return 1;
    }

    if(dumpRC)
    {
        NSString *data = [resource makeExternalForm:NULL];

        if(data == nil)
        {
            printf("Can't create .r file, abort\n");
            [pool drain];
            return 1;
        }

        printf("%s\n\n", [data UTF8String]);
    }

    if([resource applyToDMG:dmgPath] != nil)
    {
        printf("Can't apply .r file to dmg file, abort\n");
        [pool drain];
        return 1;
    }

    [pool drain];
    return 0;
}
