//
//  UIController.m
//  hourglass
//
//  Created by Matze on 24/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import "UIController.h"

@interface UIController ()

@end

@implementation UIController

- (void)deleteSelectedObjects {
    NSArray *objectArray = [_Tasks selectedObjects];
    
    for (int i = 0; i < [objectArray count]; i++) {
        NSManagedObject *mo2delete = [objectArray objectAtIndex:i];
        [[[NSApp delegate] managedObjectContext] deleteObject: mo2delete];
    }
}

#pragma Actions
- (IBAction)buttonDelete:(id)sender {
    NSUInteger row = [TableView rowForView:sender];
    [TableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:row] byExtendingSelection:NO];
    
    [self deleteSelectedObjects];
}

- (void)keyDown:(NSEvent *)event {
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    
    if(key == NSDeleteCharacter)
    {
        if([TableView selectedRow] == -1)
        {
            NSBeep();
        }
        
        BOOL isEditing = [[NSApp delegate]isEditing];
        
        if (!isEditing)
        {
            [self deleteSelectedObjects];
            return;
        }
        
    }
    
    [super keyDown:event];
}


@end
