//
//  HGButtonAdd.m
//  hourglass
//
//  Created by Matze on 20.01.14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import "HGButtonAdd.h"

@implementation HGButtonAdd

- (BOOL)wantsUpdateLayer {
    return YES;
}

- (void)updateLayer {
    if ([self.cell isHighlighted]) {
        self.layer.contents = [NSImage imageNamed:@"icon-add-pressed.png"];
    } else {
        self.layer.contents = [NSImage imageNamed:@"icon-add-default.png"];
    }
}

@end
