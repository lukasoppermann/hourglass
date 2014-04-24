//
//  UIController.h
//  hourglass
//
//  Created by Matze on 24/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UIController : NSWindowController <NSWindowDelegate> {
    IBOutlet NSTableView *TableView;
}

@property (strong) IBOutlet NSArrayController *Tasks;


- (IBAction)buttonDelete:(id)sender;
- (void)deleteSelectedObjects;

@end
