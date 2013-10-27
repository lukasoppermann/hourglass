//
//  HGPanelControllerWindowController.h
//  hourglass
//
//  Created by Matze on 22.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HGBackgroundView.h"
#import "HGStatusItemView.h"

@class HGPanelController;

@protocol HGPanelControllerDelegate <NSObject>

@optional

- (HGStatusItemView *)statusItemViewForPanelController:(HGPanelController *)controller;

@end



@interface HGPanelController : NSWindowController <NSWindowDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet HGBackgroundView *backgroundView;
@property (unsafe_unretained) IBOutlet NSButton *buttonadd;


@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<HGPanelControllerDelegate> delegate;

- (id) initWithDelegate:(id<HGPanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;

@end
