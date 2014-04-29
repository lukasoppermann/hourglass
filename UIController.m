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

- (id)initWithDelegate:(id<UIControllerDelegate>)delegate {
    self = [super initWithWindowNibName:@"UI"];
    if (self != nil) {
        _delegate = delegate;
    }
    return self;
}

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

#pragma UI Drawing & Animation

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Create Panel
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
    
    // Resize Panel
    NSRect panelRect = [[self window] frame];
    panelRect.size.height = POPUP_HEIGHT;
    [[self window] setFrame:panelRect display:NO];
}

- (NSRect)statusRectForWindow:(NSWindow *)window {
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
    statusItemView = nil;
    if ([[self delegate] respondsToSelector:@selector(statusItemViewForUIController:)]) {
        statusItemView = [[self delegate] statusItemViewForUIController:self];
    }
    
    if (statusItemView) {
        statusRect = [statusItemView globalRect];
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect) - 2 ;
    } else {
        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    
    return statusRect;
}

- (void)setHasActivePanel:(BOOL)flag
{
    if (_hasActivePanel != flag)
    {
        _hasActivePanel = flag;
        
        if (_hasActivePanel)
        {
            [self openPanel];
        }
        else
        {
            [self closePanel];
        }
    }
}


- (void)windowWillClose:(NSNotification *)notification {
    [self setHasActivePanel:NO];
}

- (void)windowDidResignKey:(NSNotification *)notification {
    if ([[self window] isVisible]) {
        [self setHasActivePanel:NO];
    }
}

- (void)windowDidResize:(NSNotification *)notification {
    NSWindow *panel = [self window];
    NSRect statusRect = [self statusRectForWindow:panel];
    NSRect panelRect = [panel frame];
    
    CGFloat statusX = roundf(NSMidX(statusRect));
    CGFloat panelX = statusX - NSMinX(panelRect);
    CGFloat maxX = NSMaxX([[self backgroundView] bounds]);
    CGFloat maxY = NSMaxY([[self backgroundView] bounds]);
    
    self.backgroundView.triangle = panelX; // @Jan: why is a setter method not possible (i.e. setTriangle)
    
    NSRect buttonRect = [[self buttonadd] frame];
    buttonRect.size.width = BUTTON_SIZE;
    buttonRect.size.height = buttonRect.size.width;
    buttonRect.origin.x = maxX - buttonRect.size.width;// * 1.5;
    buttonRect.origin.y = maxY - TRIANGLE_HEIGHT - buttonRect.size.height;// * 1.5;
    [[self buttonadd] setFrame:buttonRect];
    
//    NSRect listButtonRect = NSMakeRect(NSMinX([[self backgroundView] bounds]), buttonRect.origin.y, buttonRect.size.width, buttonRect.size.height) ;
//    [[self buttonlist] setFrame:listButtonRect];
    
    NSRect tableRect = [[self tableScrollView] frame];
    tableRect.size.width = maxX;
    tableRect.size.height = maxY - TRIANGLE_HEIGHT - buttonRect.size.height;
    tableRect.origin.x = self.backgroundView.frame.origin.x;
    tableRect.origin.y = maxY - POPUP_HEIGHT;
    
    [[self tableScrollView] setFrame:tableRect];
}

- (void)cancelOperation:(id)sender {
    [self setHasActivePanel:NO];
}

- (void)openPanel {
    NSWindow *panel = [self window];
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = [self statusRectForWindow:panel];
    
    NSRect panelRect = [panel frame];
    panelRect.size.width = PANEL_WIDTH;
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    // For testing
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown) {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask); // @Jan
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed) {
            openDuration *= 10;
            
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
        }
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
}

- (void)closePanel {
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        [[self window] orderOut:nil];
    });
}

- (NSColor*)colorForIndex:(NSInteger)index {
    NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSInteger itemCount = [context countForFetchRequest:fetchRequest error:&error];
    float val = 0;
    
    float brightness = 0.63;
    
    if( itemCount < 11 )
    {
        val = brightness + ((0.1/10)*(index*3));
    }
    else
    {
        val = brightness + ((0.1/itemCount)*(index*(3)));
    }
    
    return [NSColor     colorWithDeviceHue: 0.57
                                saturation: 0.67
                                brightness: val
                                     alpha: 1
            ];
}

- (void)tableView:(NSTableView *)tableView
    didAddRowView:(NSTableRowView *)rowView
           forRow:(NSInteger)row {
    rowView.backgroundColor = [self colorForIndex:row];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    [statusItemView setStatusContent:[object valueForKeyPath:keyPath]];
}

@end
