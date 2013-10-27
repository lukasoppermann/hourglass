//
//  HGMenuBarController.h
//  hourglass
//
//  Created by Matze on 22.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#define STATUS_ITEM_VIEW_WIDTH 80.0

#import <Foundation/Foundation.h>

@class HGStatusItemView;

@interface HGMenuBarController : NSObject

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong, readonly) HGStatusItemView *statusItemView;
@property (nonatomic) BOOL hasActiveIcon;


@end
