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
#import "HGBackgroundView.h"

#define POPUP_HEIGHT 600
#define PANEL_WIDTH 400

#define OPEN_DURATION .2
#define CLOSE_DURATION .1

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
    
    HGStatusItemView *statusItemView = nil;
    if ([[self delegate] respondsToSelector:@selector(statusItemViewForPanelController:)]) {
        statusItemView = [[self delegate] statusItemViewForPanelController:self];
    }
    
    if (statusItemView) {
        statusRect = [statusItemView globalRect];
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
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
    
    self.backgroundView.triangle = panelX; // @Jan: why is a setter method not possible (i.e. setTriangle)
    
    NSRect buttonRect = [[self buttonadd] frame];
    buttonRect.size.width = 25.0;
    buttonRect.size.height = buttonRect.size.width;
    buttonRect.origin.x = NSMaxX([[self backgroundView] bounds]) - buttonRect.size.width * 2;
    buttonRect.origin.y = NSHeight([[self backgroundView] bounds]) - TRIANGLE_HEIGHT - buttonRect.size.height;
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

@end
