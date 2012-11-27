//
//  MachOSymbolMap.m
//  ObjCDebug
//
//  Created by alxn1 on 26.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "MachOSymbolMap.h"

#import <mach-o/fat.h>
#import <mach-o/loader.h>
#import <mach-o/stab.h>

#import "MachOSymbol+Private.h"

@interface MachOFileHandle : NSObject
{
    @private
        FILE *m_File;
}

+ (MachOFileHandle*)withFile:(NSString*)path;

- (id)initWithFile:(NSString*)path;

- (BOOL)findMachOImageOffset:(MachOArchType)archType
                      offset:(off_t*)result;

- (BOOL)findCommandTableOffset:(MachOArchType)archType
                   imageOffset:(off_t)imageOffset
                        result:(off_t*)result
                  commandCount:(size_t*)commandCount;

- (BOOL)readSymbolTableCommand:(MachOArchType)archType
                   imageOffset:(off_t)imageOffset
                        result:(struct symtab_command*)result;

- (BOOL)readData:(void*)buffer size:(size_t)size atOffset:(off_t)offset;
- (NSString*)readString:(off_t)offset;
- (void)close;

@end

@implementation MachOFileHandle

+ (MachOFileHandle*)withFile:(NSString*)path
{
    return [[[MachOFileHandle alloc] initWithFile:path] autorelease];
}

- (id)initWithFile:(NSString*)path
{
    self = [super init];

    if(self == nil)
        return nil;

    m_File = fopen([path fileSystemRepresentation], "rb");

    if(m_File == NULL)
    {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [self close];
    [super dealloc];
}

- (BOOL)findMachOImageOffset:(MachOArchType)archType
                      offset:(off_t*)result
{
    struct fat_header   header          = { 0 };
    struct fat_arch     arch            = { 0 };
    cpu_type_t          nativeCPUType   = ((archType == MachOArchTypeX86)?
                                                        (CPU_TYPE_X86):
                                                        (CPU_TYPE_X86_64));

    if(![self readData:&header size:sizeof(header) atOffset:0])
        return NO;

    if(header.magic != htonl(FAT_MAGIC))
        return NO;

    *result = sizeof(header);

    size_t countArchs = ntohl(header.nfat_arch);
    for(size_t i = 0; i < countArchs; i++)
    {
        if(![self readData:&arch size:sizeof(arch) atOffset:*result])
            return NO;

        if(ntohl(arch.cputype) == nativeCPUType)
        {
            *result = ntohl(arch.offset);
            return YES;
        }

        *result += sizeof(arch);
    }

    return NO;
}

- (BOOL)findCommandTableOffset:(MachOArchType)archType
                   imageOffset:(off_t)imageOffset
                        result:(off_t*)result
                  commandCount:(size_t*)commandCount
{
    struct mach_header  machHeader      = { 0 };
    cpu_type_t          nativeCPUType   = ((archType == MachOArchTypeX86)?
                                                        (CPU_TYPE_X86):
                                                        (CPU_TYPE_X86_64));

    if(![self readData:&machHeader size:sizeof(machHeader) atOffset:imageOffset])
        return NO;

    if(machHeader.magic    != MH_MAGIC     &&
       machHeader.magic    != MH_MAGIC_64  ||
       machHeader.cputype  != nativeCPUType)
    {
        return NO;
    }

    imageOffset += sizeof(machHeader);
    if(machHeader.magic == MH_MAGIC_64)
    {
        uint32_t reserved;
        if(![self readData:&reserved size:sizeof(reserved) atOffset:imageOffset])
            return NO;

        imageOffset += sizeof(reserved);
    }

    *commandCount   = machHeader.ncmds;
    *result         = imageOffset;
    return YES;
}

- (BOOL)readSymbolTableCommand:(MachOArchType)archType
                   imageOffset:(off_t)imageOffset
                        result:(struct symtab_command*)result
{
    off_t               commandOffset   = 0;
    size_t              commandCount    = 0;
    struct load_command loadCommand     = { 0 };

    if(![self findCommandTableOffset:archType
                         imageOffset:imageOffset
                              result:&commandOffset
                        commandCount:&commandCount])
    {
        return NO;
    }

    for(size_t i = 0; i < commandCount; i++)
    {
        if(![self readData:&loadCommand
                      size:sizeof(loadCommand)
                  atOffset:commandOffset])
        {
            return NO;
        }

        if(loadCommand.cmd == LC_SYMTAB)
        {
            return [self readData:result
                             size:sizeof(struct symtab_command)
                         atOffset:commandOffset];
        }

        commandOffset += loadCommand.cmdsize;
    }

    return false;
}

- (BOOL)readData:(void*)buffer size:(size_t)size atOffset:(off_t)offset
{
    return (fseek(m_File, offset, SEEK_SET) == 0 &&
            fread(buffer, size, 1, m_File)  == 1);
}

- (NSString*)readString:(off_t)offset
{
    if(fseek(m_File, offset, SEEK_SET) != 0)
        return nil;

    NSMutableString *result = [[NSMutableString alloc] init];
    char             ch;

    while(YES)
    {
        if(fread(&ch, 1, 1, m_File) != 1)
        {
            [result release];
            result = nil;
            break;
        }

        if(ch == 0)
            break;

        [result appendFormat:@"%c", ch];
    }

    return [result autorelease];
}

- (void)close
{
    if(m_File != NULL)
    {
        fclose(m_File);
        m_File = NULL;
    }
}

@end

@implementation MachOSymbolMap

- (void)addSymbol32:(NSString*)name info:(const struct nlist*)info
{
    MachOSymbol *symbol = [MachOSymbol symbolWithName:name info32:info];
    [m_AddressMap setObject:symbol forKey:[NSNumber numberWithUnsignedLongLong:info->n_value]];
    [m_Map setObject:symbol forKey:name];
}

- (void)addSymbol64:(NSString*)name info:(const struct nlist_64*)info
{
    MachOSymbol *symbol = [MachOSymbol symbolWithName:name info:info];
    [m_AddressMap setObject:symbol forKey:[NSNumber numberWithUnsignedLongLong:info->n_value]];
    [m_Map setObject:symbol forKey:name];
}

- (BOOL)loadX86SymbolsFrom:(MachOFileHandle*)file
               imageOffset:(off_t)imageOffset
        symbolTableCommand:(const struct symtab_command*)symbolTableCommand
{
    struct nlist         info;
    size_t               symbolOffset       = imageOffset + symbolTableCommand->symoff;
    size_t               stringTableOffset  = imageOffset + symbolTableCommand->stroff;
    size_t               symbolCount        = symbolTableCommand->nsyms;
    NSString            *name               = nil;
    NSAutoreleasePool   *pool               = nil;
    BOOL                 result             = YES;

    for(size_t i = 0; i < symbolCount; i++)
    {
        pool = [[NSAutoreleasePool alloc] init];

        if(![file readData:&info size:sizeof(info) atOffset:symbolOffset])
        {
            [pool drain];
            result = NO;
            break;
        }

        if(info.n_un.n_strx != 0) // пропускаем такое
        {
            name = [file readString:stringTableOffset + info.n_un.n_strx];

            if(name == nil)
            {
                [pool drain];
                result = NO;
                break;         
            }

            [self addSymbol32:name info:&info];
        }
        
        symbolOffset += sizeof(info);
        [pool drain];
    }

    return result;
}

- (BOOL)loadX86_64SymbolsFrom:(MachOFileHandle*)file
                  imageOffset:(off_t)imageOffset
           symbolTableCommand:(const struct symtab_command*)symbolTableCommand
{
    struct nlist_64      info;
    size_t               symbolOffset       = imageOffset + symbolTableCommand->symoff;
    size_t               stringTableOffset  = imageOffset + symbolTableCommand->stroff;
    size_t               symbolCount        = symbolTableCommand->nsyms;
    NSString            *name               = nil;
    NSAutoreleasePool   *pool               = nil;
    BOOL                 result             = YES;

    for(size_t i = 0; i < symbolCount; i++)
    {
        pool = [[NSAutoreleasePool alloc] init];

        if(![file readData:&info size:sizeof(info) atOffset:symbolOffset])
        {
            [pool drain];
            result = NO;
            break;
        }

        if(info.n_un.n_strx != 0) // пропускаем такое
        {
            name = [file readString:stringTableOffset + info.n_un.n_strx];

            if(name == nil)
            {
                [pool drain];
                result = NO;
                break;         
            }

            [self addSymbol64:name info:&info];
        }
        
        symbolOffset += sizeof(info);
        [pool drain];
    }

    return result;
}

+ (MachOSymbolMap*)loadFromFile:(NSString*)path
{
#ifdef __LP64__
    return [MachOSymbolMap loadFromFile:path arch:MachOArchTypeX86_64];
#else
    return [MachOSymbolMap loadFromFile:path arch:MachOArchTypeX86];
#endif
}

+ (MachOSymbolMap*)loadFromFile:(NSString*)path arch:(MachOArchType)arch
{
    MachOFileHandle *file = [MachOFileHandle withFile:path];

    if(file == nil)
        return nil;

    off_t                   imageOffset         = 0;
    struct symtab_command   symbolTableCommand  = { 0 };

    if(![file findMachOImageOffset:arch offset:&imageOffset])
        return nil;

    if(![file readSymbolTableCommand:arch
                         imageOffset:imageOffset
                              result:&symbolTableCommand])
    {
        return nil;
    }

    MachOSymbolMap *result = [[MachOSymbolMap alloc] init];

    if(arch == MachOArchTypeX86)
    {
        if(![result loadX86SymbolsFrom:file
                           imageOffset:imageOffset
                    symbolTableCommand:&symbolTableCommand])
        {
            [result release];
            return nil;
        }
    }
    else
    {
        if(![result loadX86_64SymbolsFrom:file
                              imageOffset:imageOffset
                       symbolTableCommand:&symbolTableCommand])
        {
            [result release];
            return nil;
        }
    }

    return [result autorelease];
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Map           = [[NSMutableDictionary alloc] init];
    m_AddressMap    = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)dealloc
{
    [m_Map release];
    [m_AddressMap release];
    [super dealloc];
}

- (MachOSymbol*)findWithName:(NSString*)name
{
    return [m_Map objectForKey:name];
}

- (MachOSymbol*)findWithAddress:(uint64_t)address
{
    return [m_AddressMap objectForKey:[NSNumber numberWithUnsignedLongLong:address]];
}

- (NSEnumerator*)symbolEnumerator
{
    return [m_Map objectEnumerator];
}

@end
