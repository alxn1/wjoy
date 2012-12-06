//
//  MainController.m
//  test
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "MainController.h"

@implementation MainController

- (void)awakeFromNib
{
    // Если окно будет само показываться из xib-а, можно будет (если приглядется)
    // увидеть небольшое мерцание текста при первом появлении окна - текст будет
    // локализован чуть позже, после появления окна.
    // И тут показывать окно нельзя - awakeFromNib вызывается до процесса
    // локализации.
    [m_Window performSelector:@selector(makeKeyAndOrderFront:)
                   withObject:nil
                   afterDelay:0.0];
}

@end
