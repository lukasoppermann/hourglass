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
        _statusContent = @"--:--";
    }
    
    [self addObserver:self forKeyPath:@"statusContent" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [[self statusItem] drawStatusBarBackgroundInRect:dirtyRect withHighlight:[self isHighlighted]];
    
    NSImage *statusImage = [NSImage imageNamed:@"menu-bar-icon.png"];
    
    NSString *content = _statusContent;
    NSFont *msgFont = [NSFont menuBarFontOfSize:0]; //return default size
    NSColor *textColor = [NSColor controlTextColor];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSLeftTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    if (_isHighlighted) {
        textColor = [NSColor selectedMenuItemTextColor];
        if (!_isTiming)
            statusImage = [NSImage imageNamed:@"menu-bar-icon-highlight.png"];
    }
    
    if (_isTiming) {
        statusImage = [NSImage imageNamed:@"menu-bar-icon-active.png"];
    }
    
    NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     msgFont, NSFontAttributeName,
                                     textColor, NSForegroundColorAttributeName,
                                     paraStyle, NSParagraphStyleAttributeName,
                                     nil];
    
    NSSize statusSize = [content sizeWithAttributes:msgAttrs];
    NSRect statusRect = NSMakeRect(0, 0, statusSize.width, statusSize.height);
    statusRect.origin.x = 24; //h margin
    statusRect.origin.y = ([self frame].size.height - statusSize.height) / 2.0; //v margin

    [content drawInRect:statusRect withAttributes:msgAttrs];

    NSRect statusImgRect = NSMakeRect(0, 0, 18, 18);
    statusImgRect.origin.x = 2;
    statusImgRect.origin.y = 2;
    
    [statusImage drawInRect:statusImgRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
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

- (void)setTiming:(BOOL)newFlag
{
    if (_isTiming == newFlag) return;
    _isTiming = newFlag;
    [self setNeedsDisplay:YES];
}

- (NSRect)globalRect {
    NSRect frame = [self frame];
    frame.origin = [[self window] convertBaseToScreen:frame.origin];
    return frame;
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    [self setNeedsDisplay:YES];
}

@end
