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
    
    NSString *content = @"hg 00:00";
    
    NSFont *msgFont = [NSFont menuBarFontOfSize:0]; //return default size
    
    NSColor *textColor = [NSColor controlTextColor];
    if (_isHighlighted) {
        textColor = [NSColor selectedMenuItemTextColor];
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSCenterTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     msgFont, NSFontAttributeName,
                                     textColor, NSForegroundColorAttributeName,
                                     paraStyle, NSParagraphStyleAttributeName,
                                     nil];
    
    NSSize statusSize = [content sizeWithAttributes:msgAttrs];
    NSRect statusRect = NSMakeRect(0, 0, statusSize.width, statusSize.height);
    statusRect.origin.x = ([self frame].size.width - statusSize.width) / 2.0; //h margin
    statusRect.origin.y = ([self frame].size.height - statusSize.height) / 2.0; //v margin
    
    [content drawInRect:statusRect withAttributes:msgAttrs];
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
