//
//  TableDelegate.h
//  hourglass
//
//  Created by Matze on 21/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@interface TableDelegate : NSObject  <NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSTableView *TableView;
}

@property (strong) IBOutlet NSArrayController *Tasks;


- (IBAction)buttonDelete:(id)sender;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

@end
