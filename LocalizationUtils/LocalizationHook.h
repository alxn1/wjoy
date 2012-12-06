//
//  LocalizationHook.h
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LocalizationHook;

// Первый метод вызывается перед локализацией строки, второй - после.
// Для всех хуков методы вызываются последовательно, пока какой-то хук
// не вернет nil, или не закончатся хуки :)
//
// Если метод stringWillLocalize вернет nil, то строка не будет локализована.
//
// Строка, которую вернет stringDidLocalize - это и будет результирующая строка,
// которая будет использована для локализации. Поэтому очень важно, что бы этот
// метод не возвращал nil.
//
// tableName - это, по-сути, имя strings-файла.

@protocol LocalizationHookDelegate

- (NSString*)localizationHook:(LocalizationHook*)hook
           stringWillLocalize:(NSString*)string
                        table:(NSString*)tableName;

- (NSString*)localizationHook:(LocalizationHook*)hook
            stringDidLocalize:(NSString*)string
                        table:(NSString*)tableName;

@end

@interface LocalizationHook : NSObject
{
    @private
        BOOL                            m_IsEnabled;
        id<LocalizationHookDelegate>    m_Delegate;
}

- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)enabled;

- (id<LocalizationHookDelegate>)delegate;
- (void)setDelegate:(id<LocalizationHookDelegate>)delegate;

@end
