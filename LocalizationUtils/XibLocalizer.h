//
//  XibLocalizer.h
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Ключь XibLocalizerLocalizableXibsKey (имеет имя LocalizedXibs)
// автоматом читается из Info.plist-а, и его значения зафигачиваются в XibLocalizer.
// Он должен являться словарем, где ключами являются имена xib-ов,
// а значениями - имена strings-файлов (значения могут быть пустыми).
// За бандл считается тот, в котором содержится этот Info.plist.
// В большинстве случаев сами бандлы должны подхватываться автоматом, но это не
// оттестировано.
//
// Можно эту функциональноть не использовать, и все настраивать вручную.
// Но только ДО первой загрузки xib-ов, которые необходимо перевести.
//
// В случае, если определен макрос XIB_LOCALIZATION_DEBUG в консоль будет
// выводится всякая полезная информация о том, какие xib-ы были пропущены
// и почему.

// Если определен макрос XIB_DUMP_NON_LOCALIZED, то так же будут вывалены
// нелокализованные строки в консоль, в виде, пригодном для локализации,
// или для запихивания в .strings-файл.
// Правда, не совсем достоверно, так как наша штука может не знать о
// всей иерархии обьектов, кроме того, она не знает, что не нужно
// локализовывать, да и не которые свойства она пытается локализовать дважды :).
// Не говоря уже о том, что те строки, что содержат переменные (см. LocalizationPreprocessor),
// сразу же считаются локализоваными, даже не смотря на то, что могут быть не локализованы.
// (Но это можно обойти, если удалить все переменные из LocalizationPreprocessor-а -
// тогда строки не будут изменяться, и нелокализованые будут считаться таковыми).
//
// Если же определить XIB_DUMP_FILE, то записть будет произведена в указанный файл.
//
// Если в начале имени xib-а добавить *, то такой xib не будет переводится,
// но замена переменных все равно будет происходить. При этом можно указать
// xib и со звездочкой в начале, и без оной - приоритет будет иметь имя
// без звездочки.

APPKIT_EXTERN NSString *XibLocalizerLocalizableXibsKey;

@interface XibLocalizer : NSObject
{
    @private
        NSMutableDictionary *m_Settings;
}

+ (XibLocalizer*)sharedInstance;

// Если где-то не указан strings-файл, то считается, что это Localizable,
// если не указан бандл - то считается, что это главный бандл приложения.
// При переводе strings-файл будет браться из бандла с xib-файлом.

- (void)addXib:(NSString*)name;
- (void)addXib:(NSString*)name bundle:(NSBundle*)bundle;
- (void)addXib:(NSString*)name stringsFileName:(NSString*)stringsFileName;
- (void)addXib:(NSString*)name bundle:(NSBundle*)bundle stringsFileName:(NSString*)stringsFileName;

// вычитывает XibLocalizerLocalizableXibsKey из Info.plist-файлов, и заменяет
// текущие настройки для данного бандла в недрах данного XibLocalizer-а.
- (void)addBundle:(NSBundle*)bundle;
- (void)addBundles:(NSArray*)bundleArray;

- (void)removeXib:(NSString*)name bundle:(NSBundle*)bundle;
- (void)removeXib:(NSString*)name;

- (void)removeBundle:(NSBundle*)bundle; // удаляет все упоминания о бандле

// возвращает NSDictionary, где ключами являются NSString-пути к бандлам,
// а значениями - дргие NSDictionary. Там ключами являются имена
// xib-ов, а значениями - имена strings-файлов.
- (NSDictionary*)settings;

@end
