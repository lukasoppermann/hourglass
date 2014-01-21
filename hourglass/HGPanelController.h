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

#define POPUP_HEIGHT 600
#define PANEL_WIDTH 400

#define OPEN_DURATION .2
#define CLOSE_DURATION .1

#define BUTTON_SIZE 45.0

@class HGPanelController;

@protocol HGPanelControllerDelegate <NSObject>

@optional

- (HGStatusItemView *)statusItemViewForPanelController:(HGPanelController *)controller;

@end



@interface HGPanelController : NSWindowController <NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSTableView *HGTableView;
    HGStatusItemView *statusItemView;
}

@property (nonatomic, unsafe_unretained) IBOutlet HGBackgroundView *backgroundView;
@property (strong) IBOutlet NSButton *buttonadd;
@property (strong) IBOutlet NSButton *buttonlist;
@property (strong) IBOutlet NSButton *buttonstartstop;
@property (nonatomic, unsafe_unretained) IBOutlet NSScrollView *tableView;
@property NSMutableArray *tasks;
@property (strong) IBOutlet NSArrayController *arrayController;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<HGPanelControllerDelegate> delegate;

- (id) initWithDelegate:(id<HGPanelControllerDelegate>)delegate;
- (NSColor*)colorForIndex:(NSInteger)index;

- (void)openPanel;
- (void)closePanel;

- (IBAction)buttonAdd:(id)sender;
- (IBAction)buttonDelete:(id)sender;

- (IBAction)startStopTimer:(id)sender;

@end
