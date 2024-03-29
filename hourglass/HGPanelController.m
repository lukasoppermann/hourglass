//
//  HGPanelControllerWindowController.m
//  hourglass
//
//  Created by Matze on 22.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import "HGPanelController.h"
#import "HGStatusItemView.h"
#import "HGMenuBarController.h"
#import "HGTask.h"
#import "HGBackgroundView.h"

@implementation HGPanelController

- (id)initWithDelegate:(id<HGPanelControllerDelegate>)delegate {
    self = [super initWithWindowNibName:@"HGPanel"];
    if (self != nil) {
        _delegate = delegate;
    }
    return self;
}

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
    if ([[self delegate] respondsToSelector:@selector(statusItemViewForPanelController:)]) {
        statusItemView = [[self delegate] statusItemViewForPanelController:self];
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
    
    NSRect listButtonRect = NSMakeRect(NSMinX([[self backgroundView] bounds]), buttonRect.origin.y, buttonRect.size.width, buttonRect.size.height) ;
    [[self buttonlist] setFrame:listButtonRect];
    
    NSRect tableRect = [[self tableView] frame];
    tableRect.size.width = maxX;
    tableRect.size.height = maxY - TRIANGLE_HEIGHT - buttonRect.size.height;
    tableRect.origin.x = self.backgroundView.frame.origin.x;
    tableRect.origin.y = maxY - POPUP_HEIGHT;
    
    [[self tableView] setFrame:tableRect];
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
    NSInteger itemCount = [_tasks count];
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

- (IBAction)buttonAdd:(id)sender {
    if (_tasks == nil) {
        _tasks = [NSMutableArray new];
    }
    [_arrayController insertObject:[[HGTask alloc] init] atArrangedObjectIndex:0];

    [HGTableView editColumn:0 row:0 withEvent:NULL select:YES];
    
    [[_tasks objectAtIndex:0] addObserver:self forKeyPath:@"totalTime" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)keyDown:(NSEvent *)event {
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    
    if(key == NSDeleteCharacter)
    {
        if([HGTableView selectedRow] == -1)
        {
            NSBeep();
        }
        
        BOOL isEditing = ([[self.window firstResponder] isKindOfClass:[NSText class]]);

        if (!isEditing)
        {
            [self deleteItem];
            return;
        }
        
    }
    
    [super keyDown:event];
}

- (void)deleteItem {
    NSInteger row = [HGTableView selectedRow];
    [HGTableView abortEditing];
    if (row != -1) {
        [[_tasks objectAtIndex:row] removeObserver:self forKeyPath:@"totalTime"];
        [_arrayController removeObjectAtArrangedObjectIndex:row];
        [statusItemView setTiming:FALSE]; //set icon state
    }
        [HGTableView reloadData];
}

- (IBAction)startStopTimer:(id)sender {
    NSInteger row = [HGTableView rowForView:sender];
    
    BOOL anyActive = '\0';
    int count = 0;
    HGTask *activeTimer = [HGTask new];
    while (anyActive == FALSE && count < [_tasks count]) {
        activeTimer = [_tasks objectAtIndex:count];
        anyActive = [activeTimer hasActiveTimer];
        count++;
    }
    
    if([[_tasks objectAtIndex:row] hasActiveTimer]) {
        [[_tasks objectAtIndex:row] stopTimer];
        [statusItemView setTiming:FALSE]; //set icon state
    } else {
        if (anyActive) {
            [activeTimer stopTimer]; //stop other active timer
        }
        [[_tasks objectAtIndex:row] startTimer];
        [statusItemView setTiming:TRUE]; //set icon state
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    [statusItemView setStatusContent:[object valueForKeyPath:keyPath]];
}

@end
