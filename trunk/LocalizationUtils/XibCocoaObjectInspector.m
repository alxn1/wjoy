//
//  XibCocoaObjectInspector.m
//  XibLocalization
//
//  Created by alxn1 on 04.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "XibCocoaObjectInspector.h"

#import "NSMatrix+ToolTipItem.h"

@implementation XibCocoaObjectInspector

+ (void)load
{
    [XibObjectInspector registerSubClass:[XibCocoaObjectInspector class]];
}

- (NSSet*)handledXibClassNames
{
    static NSSet *result = nil;

    if(result == nil)
    {
        result = [[NSSet alloc] initWithObjects:
                    @"NSMenu",
                    @"NSMenuItem",
                    @"NSApplication",
                    @"NSFontManager",
                    @"NSResponder",
                    @"NSWindow",
                    @"NSPanel",
                    @"NSView",
                    @"NSBox",
                    @"NSClipView",
                    @"NSScroller",
                    @"NSScrollView",
                    @"NSControl",
                    @"NSButton",
                    @"NSTextField",
                    @"NSTableView",
                    @"NSTableColumn",
                    @"NSTableHeaderView",
                    @"NSTableHeaderCell",
                    @"NSOutlineView",
                    @"NSTabView",
                    @"NSTabViewItem",
                    @"NSDrawer",
                    @"NSToolbar",
                    @"NSToolbarItem",
                    @"NSToolbarSpaceItem",
                    @"NSToolbarSeparatorItem",
                    @"NSToolbarFlexibleSpaceItem",
                    @"NSColorWell",
                    @"NSSlider",
                    @"NSProgressIndicator",
                    @"NSLevelIndicator",
                    @"NSTokenField",
                    @"NSDatePicker",
                    @"NSStepper",
                    @"NSImageView",
                    @"NSPopUpButton",
                    @"NSTextView",
                    @"NSMatrix",
                    @"NSMatrixToolTipItem",
                    @"NSForm",
                    @"NSFormCell",
                    @"NSButtonCell",
                    @"NSConcreteTextStorage",
                    @"NSTextStorage",
                    @"NSComboBox",
                    @"NSComboBoxItem",
                    @"NSSegmentedControl",
                    @"NSSegmentedControlItem",
                    @"_NSCornerView",
                    nil];
    }

    return result;
}

- (void)extractProperties:(NSMutableArray*)propertiesArray
{
    [self extractProperty:propertiesArray getMethod:@selector(label) setMethod:@selector(setLabel:)];
    [self extractProperty:propertiesArray getMethod:@selector(toolTip) setMethod:@selector(setToolTip:)];
    [self extractProperty:propertiesArray getMethod:@selector(headerToolTip) setMethod:@selector(setHeaderToolTip:)];
    [self extractProperty:propertiesArray getMethod:@selector(alternateTitle) setMethod:@selector(setAlternateTitle:)];
    [self extractProperty:propertiesArray getMethod:@selector(placeholderString) setMethod:@selector(setPlaceholderString:)];
    [self extractProperty:propertiesArray getMethod:@selector(paletteLabel) setMethod:@selector(setPaletteLabel:)];

    if(![[self xibObject] isKindOfClass:[NSImageView class]])
        [self extractProperty:propertiesArray getMethod:@selector(stringValue) setMethod:@selector(setStringValue:)];

    if(![[self xibObject] isKindOfClass:[NSPopUpButton class]])
        [self extractProperty:propertiesArray getMethod:@selector(title) setMethod:@selector(setTitle:)];
}

- (void)extractChildren:(NSMutableArray*)childrenArray
{
    [self extractChildren:childrenArray method:@selector(menu)];
    [self extractChildren:childrenArray method:@selector(view)];
    [self extractChildren:childrenArray method:@selector(cells)];
    [self extractChildren:childrenArray method:@selector(items)];
    [self extractChildren:childrenArray method:@selector(submenu)];
    [self extractChildren:childrenArray method:@selector(toolbar)];
    [self extractChildren:childrenArray method:@selector(subviews)];
    [self extractChildren:childrenArray method:@selector(itemArray)];
    [self extractChildren:childrenArray method:@selector(headerCell)];
    [self extractChildren:childrenArray method:@selector(contentView)];
    [self extractChildren:childrenArray method:@selector(textStorage)];
    [self extractChildren:childrenArray method:@selector(tableColumns)];
    [self extractChildren:childrenArray method:@selector(tabViewItems)];
    [self extractChildren:childrenArray method:@selector(toolTipItems)];
    [self extractChildren:childrenArray method:@selector(menuFormRepresentation)];       
}

@end
