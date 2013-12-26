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
#import "HGTableViewController.h"

@class HGPanelController;

@protocol HGPanelControllerDelegate <NSObject>

@optional

- (HGStatusItemView *)statusItemViewForPanelController:(HGPanelController *)controller;

@end



@interface HGPanelController : NSWindowController <NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSTableView *HGTableView;
}

@property (nonatomic, unsafe_unretained) IBOutlet HGBackgroundView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet NSButton *buttonadd;
@property (nonatomic, unsafe_unretained) IBOutlet NSScrollView *tableView;
@property NSMutableArray *tasks;



@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<HGPanelControllerDelegate> delegate;

- (id) initWithDelegate:(id<HGPanelControllerDelegate>)delegate;
- (NSColor*)colorForIndex:(NSInteger)index;

- (void)openPanel;
- (void)closePanel;

- (IBAction)buttonAdd:(id)sender;
- (IBAction)buttonDelete:(id)sender;

//@property (strong) IBOutlet NSArrayController *ArrayController;
@end
