//
//  UIController.h
//  hourglass
//
//  Created by Matze on 24/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GlobalProperties.h"
#import "StatusItemView.h"
#import "BackgroundView.h"
#import "RFOverlayScrollView.h"

@class UIController;

@protocol UIControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForUIController:(UIController *)controller;

@end

@interface UIController : NSWindowController <NSWindowDelegate> {
    IBOutlet NSTableView *TableView;
    StatusItemView *statusItemView;
}

//TODO: Split Controller function for views into separate Controller Classes (i.e. BackgroundViewController)
@property (nonatomic, unsafe_unretained) IBOutlet BackgroundView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet RFOverlayScrollView *tableScrollView;

@property (strong) IBOutlet NSButton *buttonadd;
@property (strong) IBOutlet NSArrayController *Tasks;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<UIControllerDelegate> delegate;

- (id) initWithDelegate:(id<UIControllerDelegate>)delegate;
- (void)openPanel;
- (void)closePanel;
- (void)deleteSelectedObjects;
- (NSColor*)colorForIndex:(NSInteger)index;

- (IBAction)buttonDelete:(id)sender;


@end
