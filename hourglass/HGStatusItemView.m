//
//  HGStatusItemView.m
//  hourglass
//
//  Created by Matze on 13.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import "HGStatusItemView.h"
#import "HGAppDelegate.h"

@implementation HGStatusItemView

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
    CGFloat width = [statusItem length];
    CGFloat height = [[NSStatusBar systemStatusBar] thickness];
    NSRect frame = NSMakeRect(0.0, 0.0, width, height);
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        _statusItem = statusItem;
        _statusItem.view = self;
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [[self statusItem] drawStatusBarBackgroundInRect:dirtyRect withHighlight:[self isHighlighted]];
    
    NSString *content = @"00:00";
//    NSImage *img = [NSImage imageNamed:@"menu-bar-icon.png"];
//    [img setSize:NSMakeSize(16,16)];
    NSBundle *bundle = [NSBundle mainBundle];
    NSImage *statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"menu-bar-icon" ofType:@"png"]];
//  [statusImage setSize:NSMakeSize(16,16)];
//  statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"rh" ofType:@"png"]];
//  [[self statusItem] setImage:statusImage];
    
    NSFont *msgFont = [NSFont menuBarFontOfSize:0]; //return default size
    
    NSColor *textColor = [NSColor controlTextColor];
    if (_isHighlighted) {
        textColor = [NSColor selectedMenuItemTextColor];
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSLeftTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     msgFont, NSFontAttributeName,
                                     textColor, NSForegroundColorAttributeName,
                                     paraStyle, NSParagraphStyleAttributeName,
                                     nil];
    
    NSSize statusSize = [content sizeWithAttributes:msgAttrs];
    NSRect statusRect = NSMakeRect(0, 0, statusSize.width, statusSize.height);
    NSRect statusImgRect = NSMakeRect(0, 0, 18, 18);//statusSize.width, statusSize.height);
    statusRect.origin.x = ([self frame].size.width - statusSize.width) / 2.0; //h margin
    statusRect.origin.y = ([self frame].size.height - statusSize.height) / 2.0; //v margin
    statusImgRect.origin.x = 2;
    statusImgRect.origin.y = 1;
    
    [content drawInRect:statusRect withAttributes:msgAttrs];
    [statusImage drawInRect:statusImgRect];
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)setHighlighted:(BOOL)newFlag
{
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}

- (NSRect)globalRect {
    NSRect frame = [self frame];
    frame.origin = [[self window] convertBaseToScreen:frame.origin];
    return frame;
}

@end
