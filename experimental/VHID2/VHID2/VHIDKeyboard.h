//
//  VHIDKeyboard.h
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDDevice.h"

/*
	0x00	Reserved (no event indicated)
	0x01	Keyboard ErrorRollOver
	0x02	Keyboard POSTFail
	0x03	Keyboard ErrorUndefined
*/

typedef enum {
    VHIDKeyboardButtonTypeA                 = 0x04,
    VHIDKeyboardButtonTypeB                 = 0x05,
    VHIDKeyboardButtonTypeC                 = 0x06,
    VHIDKeyboardButtonTypeD                 = 0x07,
    VHIDKeyboardButtonTypeE                 = 0x08,
    VHIDKeyboardButtonTypeF                 = 0x09,
    VHIDKeyboardButtonTypeG                 = 0x0A,
    VHIDKeyboardButtonTypeH                 = 0x0B,
    VHIDKeyboardButtonTypeI                 = 0x0C,
    VHIDKeyboardButtonTypeJ                 = 0x0D,
    VHIDKeyboardButtonTypeK                 = 0x0E,
    VHIDKeyboardButtonTypeL                 = 0x0F,
    VHIDKeyboardButtonTypeM                 = 0x10,
    VHIDKeyboardButtonTypeN                 = 0x11,
    VHIDKeyboardButtonTypeO                 = 0x12,
    VHIDKeyboardButtonTypeP                 = 0x13,
    VHIDKeyboardButtonTypeQ                 = 0x14,
    VHIDKeyboardButtonTypeR                 = 0x15,
    VHIDKeyboardButtonTypeS                 = 0x16,
    VHIDKeyboardButtonTypeT                 = 0x17,
    VHIDKeyboardButtonTypeU                 = 0x18,
    VHIDKeyboardButtonTypeV                 = 0x19,
    VHIDKeyboardButtonTypeW                 = 0x1A,
    VHIDKeyboardButtonTypeX                 = 0x1B,
    VHIDKeyboardButtonTypeY                 = 0x1C,
    VHIDKeyboardButtonTypeZ                 = 0x1D,

    VHIDKeyboardButtonType1                 = 0x1E,
    VHIDKeyboardButtonType2                 = 0x1F,
    VHIDKeyboardButtonType3                 = 0x20,
    VHIDKeyboardButtonType4                 = 0x21,
    VHIDKeyboardButtonType5                 = 0x22,
    VHIDKeyboardButtonType6                 = 0x23,
    VHIDKeyboardButtonType7                 = 0x24,
    VHIDKeyboardButtonType8                 = 0x25,
    VHIDKeyboardButtonType9                 = 0x26,
    VHIDKeyboardButtonType0                 = 0x27,

    VHIDKeyboardButtonTypeRETURN            = 0x28,
    VHIDKeyboardButtonTypeESCAPE            = 0x29,
    VHIDKeyboardButtonTypeBACKSPACE         = 0x2A,
    VHIDKeyboardButtonTypeTAB               = 0x2B,
    VHIDKeyboardButtonTypeSPACE             = 0x2C,
    VHIDKeyboardButtonTypeMINUS             = 0x2D, // -
    VHIDKeyboardButtonTypeEQUALS            = 0x2E, // =
    VHIDKeyboardButtonTypeLEFTBRACKET       = 0x2F, // [
    VHIDKeyboardButtonTypeRIGHTBRACKET      = 0x30, // ]
    VHIDKeyboardButtonTypeBACKSLASH         = 0x31, // '\'
    VHIDKeyboardButtonTypeNONUSHASH         = 0x32, // `
    VHIDKeyboardButtonTypeSEMICOLON         = 0x33, // ;
    VHIDKeyboardButtonTypeAPOSTROPHE        = 0x34, // '
    VHIDKeyboardButtonTypeGRAVE             = 0x35, // `
    VHIDKeyboardButtonTypeCOMMA             = 0x36, // ,
    VHIDKeyboardButtonTypePERIOD            = 0x37, // .
    VHIDKeyboardButtonTypeSLASH             = 0x38, // '/'

    VHIDKeyboardButtonTypeCAPSLOCK          = 0x39,

    VHIDKeyboardButtonTypeF1                = 0x3A,
    VHIDKeyboardButtonTypeF2                = 0x3B,
    VHIDKeyboardButtonTypeF3                = 0x3C,
    VHIDKeyboardButtonTypeF4                = 0x3D,
    VHIDKeyboardButtonTypeF5                = 0x3E,
    VHIDKeyboardButtonTypeF6                = 0x3F,
    VHIDKeyboardButtonTypeF7                = 0x40,
    VHIDKeyboardButtonTypeF8                = 0x41,
    VHIDKeyboardButtonTypeF9                = 0x42,
    VHIDKeyboardButtonTypeF10               = 0x43,
    VHIDKeyboardButtonTypeF11               = 0x44,
    VHIDKeyboardButtonTypeF12               = 0x45,

    VHIDKeyboardButtonTypePRINTSCEEN        = 0x46,
    VHIDKeyboardButtonTypeSCROLLLOCK        = 0x47,
    VHIDKeyboardButtonTypePAUSE             = 0x48,
    VHIDKeyboardButtonTypeINSERT            = 0x49,
    VHIDKeyboardButtonTypeHOME              = 0x4A,
    VHIDKeyboardButtonTypePAGEUP            = 0x4B,
    VHIDKeyboardButtonTypeDELETE            = 0x4C,
    VHIDKeyboardButtonTypeEND               = 0x4D,
    VHIDKeyboardButtonTypePAGEDOWN          = 0x4E,

    VHIDKeyboardButtonTypeRIGHT             = 0x4F,
    VHIDKeyboardButtonTypeLEFT              = 0x50,
    VHIDKeyboardButtonTypeDOWN              = 0x51,
    VHIDKeyboardButtonTypeUP                = 0x52,

    VHIDKeyboardButtonTypeKP_NUMLOCK        = 0x53,
    VHIDKeyboardButtonTypeKP_DIVIDE         = 0x54,
    VHIDKeyboardButtonTypeKP_MULTIPLY       = 0x55,
    VHIDKeyboardButtonTypeKP_MINUS          = 0x56,
    VHIDKeyboardButtonTypeKP_PLUS           = 0x57,
    VHIDKeyboardButtonTypeKP_ENTER          = 0x58,
    VHIDKeyboardButtonTypeKP_1              = 0x59,
    VHIDKeyboardButtonTypeKP_2              = 0x5A,
    VHIDKeyboardButtonTypeKP_3              = 0x5B,
    VHIDKeyboardButtonTypeKP_4              = 0x5C,
    VHIDKeyboardButtonTypeKP_5              = 0x5D,
    VHIDKeyboardButtonTypeKP_6              = 0x5E,
    VHIDKeyboardButtonTypeKP_7              = 0x5F,
    VHIDKeyboardButtonTypeKP_8              = 0x60,
    VHIDKeyboardButtonTypeKP_9              = 0x61,
    VHIDKeyboardButtonTypeKP_0              = 0x62,
    VHIDKeyboardButtonTypeKP_PERIOD         = 0x63,

    VHIDKeyboardButtonTypeNON_US_BACKSLASH  = 0x64,
    VHIDKeyboardButtonTypeAPPLICATION       = 0x65,
    VHIDKeyboardButtonTypePOWER             = 0x66,

    VHIDKeyboardButtonTypeKP_EQUALS         = 0x67,

    VHIDKeyboardButtonTypeF13               = 0x68,
    VHIDKeyboardButtonTypeF14               = 0x69,
    VHIDKeyboardButtonTypeF15               = 0x6A,
    VHIDKeyboardButtonTypeF16               = 0x6B,
    VHIDKeyboardButtonTypeF17               = 0x6C,
    VHIDKeyboardButtonTypeF18               = 0x6D,
    VHIDKeyboardButtonTypeF19               = 0x6E,
    VHIDKeyboardButtonTypeF20               = 0x6F,
    VHIDKeyboardButtonTypeF21               = 0x70,
    VHIDKeyboardButtonTypeF22               = 0x71,
    VHIDKeyboardButtonTypeF23               = 0x72,
    VHIDKeyboardButtonTypeF24               = 0x73,

    VHIDKeyboardButtonTypeEXECUTE           = 0x74,
    VHIDKeyboardButtonTypeHELP              = 0x75,
    VHIDKeyboardButtonTypeMENU              = 0x76,
    VHIDKeyboardButtonTypeSELECT            = 0x77,
    VHIDKeyboardButtonTypeSTOP              = 0x78,
    VHIDKeyboardButtonTypeAGAIN             = 0x79,
    VHIDKeyboardButtonTypeUNDO              = 0x7A,
    VHIDKeyboardButtonTypeCUT               = 0x7B,
    VHIDKeyboardButtonTypeCOPY              = 0x7C,
    VHIDKeyboardButtonTypePASTE             = 0x7D,
    VHIDKeyboardButtonTypeFIND              = 0x7E,
    VHIDKeyboardButtonTypeMUTE              = 0x7F,
    VHIDKeyboardButtonTypeVOLUMEUP          = 0x80,
    VHIDKeyboardButtonTypeVOLUMEDOWN        = 0x81,

    VHIDKeyboardButtonTypeLOCK_CAPSLOCK     = 0x82,
    VHIDKeyboardButtonTypeLOCK_NUMLOCK      = 0x83,
    VHIDKeyboardButtonTypeLOCK_SCROLLLOCK   = 0x84,

    VHIDKeyboardButtonTypeKP_COMMA          = 0x85,
    VHIDKeyboardButtonTypeKP_EQUALS2        = 0x86,

    VHIDKeyboardButtonTypeINETRNATIONAL1    = 0x87,
    VHIDKeyboardButtonTypeINETRNATIONAL2    = 0x88,
    VHIDKeyboardButtonTypeINETRNATIONAL3    = 0x89,
    VHIDKeyboardButtonTypeINETRNATIONAL4    = 0x8A,
    VHIDKeyboardButtonTypeINETRNATIONAL5    = 0x8B,
    VHIDKeyboardButtonTypeINETRNATIONAL6    = 0x8C,
    VHIDKeyboardButtonTypeINETRNATIONAL7    = 0x8D,
    VHIDKeyboardButtonTypeINETRNATIONAL8    = 0x8E,
    VHIDKeyboardButtonTypeINETRNATIONAL9    = 0x8F,

    VHIDKeyboardButtonTypeLANG1             = 0x90,
    VHIDKeyboardButtonTypeLANG2             = 0x91,
    VHIDKeyboardButtonTypeLANG3             = 0x92,
    VHIDKeyboardButtonTypeLANG4             = 0x93,
    VHIDKeyboardButtonTypeLANG5             = 0x94,
    VHIDKeyboardButtonTypeLANG6             = 0x95,
    VHIDKeyboardButtonTypeLANG7             = 0x96,
    VHIDKeyboardButtonTypeLANG8             = 0x97,
    VHIDKeyboardButtonTypeLANG9             = 0x98,

    VHIDKeyboardButtonTypeALT_ERASE         = 0x99,
    VHIDKeyboardButtonTypeSYSREQ            = 0x9A,

    VHIDKeyboardButtonTypeCANCEL            = 0x9B,
    VHIDKeyboardButtonTypeCLEAR             = 0x9C,
    VHIDKeyboardButtonTypePRIOR             = 0x9D,
    VHIDKeyboardButtonTypeRETURN2           = 0x9E,
    VHIDKeyboardButtonTypeSEPARATOR         = 0x9F,
    VHIDKeyboardButtonTypeOUT               = 0xA0,
    VHIDKeyboardButtonTypeOPER              = 0xA1,
    VHIDKeyboardButtonTypeCLEARAGAIN        = 0xA2,
    VHIDKeyboardButtonTypeCRSEL             = 0xA3,
    VHIDKeyboardButtonTypeEXSEL             = 0xA4,

    // some other keycodes

    VHIDKeyboardButtonTypeLeftCTRL          = 0xE0,
    VHIDKeyboardButtonTypeLeftSHIFT         = 0xE1,
    VHIDKeyboardButtonTypeLeftALT           = 0xE2,
    VHIDKeyboardButtonTypeLeftCMD           = 0xE3,
    VHIDKeyboardButtonTypeRightCTRL         = 0xE4,
    VHIDKeyboardButtonTypeRightSHIFT        = 0xE5,
    VHIDKeyboardButtonTypeRightALT          = 0xE6,
    VHIDKeyboardButtonTypeRightCMD          = 0xE7

    // some other keycodes

} VHIDKeyboardButtonType;

@interface VHIDKeyboard : VHIDDevice

+ (VHIDKeyboard*)keyboard;

- (BOOL)isButtonPressed:(VHIDKeyboardButtonType)button;
- (void)setButton:(VHIDKeyboardButtonType)button pressed:(BOOL)pressed;

@end
