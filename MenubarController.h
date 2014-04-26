//
//  MenubarController.h
//  hourglass
//
//  Created by Matze on 25/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalProperties.h"
#import "StatusItemView.h"

@class StatusItemView;

@interface MenubarController : NSObject

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong, readonly) StatusItemView *statusItemView;
@property (nonatomic) BOOL hasActiveIcon;

@end