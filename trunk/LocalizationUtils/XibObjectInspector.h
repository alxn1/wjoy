//
//  XibObjectInspector.h
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <LocalizationUtils/XibObjectProperty.h>

@interface XibObjectInspector : NSObject
{
    @private
        id m_XibObject;
}

// Проходит по всем plugin-ам, и проверяет на соответствие класс обьекта
// поддерживаемым классам того или иного плагина. Если такого класса нет -
// начинает искать плагиы для супер-класса, и так далее.
// В случае, если нет точного соответствия (или вообще его нет),
// может писать об этом в консоль, при наличие макроса XIB_LOCALIZATION_DEBUG.

+ (void)extractXibObject:(id)xibObject
              properties:(NSMutableArray*)properties
                children:(NSMutableArray*)children;

@end
