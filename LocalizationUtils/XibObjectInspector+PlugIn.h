//
//  XibObjectInspector+PlugIn.h
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <LocalizationUtils/XibObjectInspector.h>

@interface XibObjectInspector (PlugIn)

// этот метод должен быть вызван из класса-наследника,
// в методе + (void)load; Иначе плагин не будет зарегистрирован,
// и не будет использоваться при локализации xib-ов.

+ (void)registerSubClass:(Class)cls;

// утилиты, которые можно (и нужно) использовать в классах-наследниках.

- (id)xibObject;

- (BOOL)extractProperty:(NSMutableArray*)propertiesArray
              getMethod:(SEL)getMethod
              setMethod:(SEL)setMethod;

- (BOOL)extractChildren:(NSMutableArray*)childrenArray method:(SEL)method;

// методы, которые необходимо переопределить и реализовать.

- (NSSet*)handledXibClassNames;
- (void)extractProperties:(NSMutableArray*)propertiesArray;
- (void)extractChildren:(NSMutableArray*)childrenArray;

@end
