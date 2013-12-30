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
#import "HGTableViewController.h"
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
    
    HGStatusItemView *statusItemView = nil;
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

- (void)setupCALayer {
    CALayer *tableLayer = [CALayer layer];
    
    [tableLayer setNeedsDisplay];
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
    NSLog(@"button width: %f, button height: %f", buttonRect.size.width, buttonRect.size.height);
    
    [[self buttonadd] setFrame:buttonRect];
    
    
    NSRect tableRect = [[self tableView] frame];
    tableRect.size.width = maxX;
    tableRect.size.height = maxY - TRIANGLE_HEIGHT - buttonRect.size.height;
    tableRect.origin.x = self.backgroundView.frame.origin.x;
    tableRect.origin.y = maxY - POPUP_HEIGHT;
    
    [[self tableView] setFrame:tableRect];
    [[self tableView] setWantsLayer:YES];
    
    CALayer *tableLayer = [CALayer layer];
    [tableLayer setCornerRadius:CORNER_RADIUS];
    [[self tableView] setLayer:tableLayer];
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

- (NSColor*)colorForIndex:(NSInteger) index {
    NSInteger itemCount = [_tasks count];
    float val = 0;
    // we need an array with all colors (values Hue, Stauration, Brightness and a key which object is changed (for some colors its hue))
    // than we need to change the object to change (Hue or Brightness) like it does it not in the if condition
    // afterwards we add all the values to the NSColor
    // to get the right hue form my specs take the clor (in demo 205) and devide by 360
    // array e.g. (php syntax)
    /* colors[blue] = array(
                    hue = 0.57,
                    saturation = 0.67,
                    brightness = 0.63,
                    change = 'brightness'
    )
    
     val[hue] = colors[blue][hue];
     val[saturation] = colors[blue][saturation];
     val[brightness] = colors[blue][brightness];
     // in the if condition we need
    
     if(...){
        val[colors[blue][change]] = colors[blue][colors[blue][change]] + ((0.1/itemCount)*(index*(3)));
     }
     and in at the bottom we need
     
     return [NSColor     colorWithDeviceHue: val[hue]
     saturation: val[saturation]
     brightness: val[brightness]
     alpha: 1
     ];
     
    */
    // blue
    float brightness = 0.63;

    if( itemCount < 11 )
    {
        val = brightness + ((0.1/10)*(index*3));
    }
    else
    {
        val = brightness + ((0.1/itemCount)*(index*(3)));
    }
    // NSLog(@"%f", val);
    
    return [NSColor     colorWithDeviceHue: 0.57
                                saturation: 0.67
                                brightness: val
                                     alpha: 1
           ];
        
        
        //colorWithSRGBRed:1.0 green: val blue:0 alpha:1.0];

}

- (void)tableView:(NSTableView *)tableView
    didAddRowView:(NSTableRowView *)rowView
           forRow:(NSInteger)row {
    rowView.backgroundColor = [self colorForIndex:row];
    //NSLog(@"color is %@ and row is %li", rowView.backgroundColor, (long)row);
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_tasks count];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    cellView.textField.stringValue = [[_tasks objectAtIndex:row] tasklabel];
    
    return cellView;
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row {
    HGTask *task = [_tasks objectAtIndex:row];
    [task setValue:object forKey:[tableColumn identifier]];
}

- (IBAction)buttonAdd:(id)sender {
    if (_tasks == nil) {
        _tasks = [NSMutableArray new];
    }
    
//    //Draw border on click
//    NSRect borderRect = [[self buttonadd] frame];
//    NSBezierPath *borderPath = [NSBezierPath bezierPath];
//    [borderPath moveToPoint:NSMakePoint(borderRect.origin.x, borderRect.origin.x)];
//    [borderPath lineToPoint:NSMakePoint(borderRect.origin.x + borderRect.size.width, borderRect.origin.y)];
//    [borderPath lineToPoint:NSMakePoint(borderRect.origin.x + borderRect.size.width, borderRect.origin.y + borderRect.size.height)];
//    [borderPath lineToPoint:NSMakePoint(borderRect.origin.x, borderRect.origin.y + borderRect.size.height)];
//    [borderPath closePath];
////    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, 100, 100)];//[[self buttonadd] frame]];
//    [borderPath setLineWidth:10];
//    [[NSColor blackColor] setStroke];
//    [borderPath stroke];
////    [NSGraphicsContext saveGraphicsState];
////    [NSGraphicsContext restoreGraphicsState];
    
    [_tasks addObject:[[HGTask alloc] init]];
    [HGTableView reloadData];
}

- (IBAction)buttonDelete:(id)sender {
    NSInteger row = [HGTableView rowForView:sender];
    [HGTableView abortEditing];
    if (row != -1)
        [_tasks removeObjectAtIndex:row];
    [HGTableView reloadData];
}

@end
