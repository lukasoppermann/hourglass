//
//  HGMenuBarController.m
//  hourglass
//
//  Created by Matze on 22.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import "HGMenuBarController.h"
#import "HGStatusItemView.h"

@implementation HGMenuBarController

- (id) init {
    self = [super init];
    if (self != nil) {
        // creates status item in system status bar
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[HGStatusItemView alloc] initWithStatusItem:statusItem];
        _statusItemView.action = @selector(togglePanel:);
    }
    return self;
}

- (BOOL)hasActiveIcon {
    return [[self statusItemView] isHighlighted];
}

- (void)setHasActiveIcon:(BOOL)flag {
    [[self statusItemView] setIsHighlighted:flag];
}

@end
