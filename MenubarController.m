//
//  MenubarController.m
//  hourglass
//
//  Created by Matze on 25/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import "MenubarController.h"

@implementation MenubarController

- (id) init {
    self = [super init];
    if (self != nil) {
        // creates status item in system status bar
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem];
        _statusItemView.action = @selector(togglePanel:);
    }
    return self;
}

- (BOOL)hasActiveIcon {
    return [[self statusItemView] isHighlighted];
}

- (void)setHasActiveIcon:(BOOL)flag {
    [[self statusItemView] setHighlighted:flag];
}


@end
