//
//  TableDelegate.m
//  hourglass
//
//  Created by Matze on 21/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import "TableDelegate.h"

@implementation TableDelegate

- (IBAction)buttonDelete:(id)sender {
    NSUInteger row = [TableView rowForView:sender];
    [TableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:row] byExtendingSelection:NO];

    NSManagedObjectContext *context = [NSApp managedObjectContext];
    
    [context deleteObject:[self objectatindex:row]];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
    // Remove device from table view
    [self.devices removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

}


- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    
}

@end
