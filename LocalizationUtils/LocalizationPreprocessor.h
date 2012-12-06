//
//  LocalizationPreprocessor.h
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Обьект этого класса (который всегда один), перехватывает все
// строки, которые необходимо локализовать, и заменяет в них имена
// переменных, о которых знает, на их значения.
//
// Переменные в строке должны быть в виде: {%VARIABLE_NAME%} -
// именно так, и никак иначе :) Регистр имеет значение!
//
// По-умолчанию данный класс имеет в своем составе следующие переменные:
//
// APP_NAME             - имя приложения (локализованое)
// APP_VERSION          - версия приложения
// APP_SHORT_VERSION    - короткая версия приложения (без CFBundleVersion).
//
// ВНИМАНИЕ!!! Если препроцессор не знат о какой-то переменной,
// то он ее оставит в строке как есть.

@interface LocalizationPreprocessor : NSObject
{
    @private
        NSMutableDictionary *m_Variables;
}

+ (LocalizationPreprocessor*)sharedInstance;

- (NSDictionary*)variables;
- (void)setVariable:(NSString*)name value:(NSString*)value;
- (void)removeVariable:(NSString*)name;

- (NSString*)preprocessString:(NSString*)string;

@end
