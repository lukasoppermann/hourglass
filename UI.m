//
//  UI.m
//  hourglass
//
//  Created by Matze on 21/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import "UI.h"

@implementation UI

- (BOOL)canBecomeKeyWindow {
    // because the window is borderless, we have to make it active
    return YES;
}

- (BOOL)canBecomeMainWindow {
    // because the window is borderless, we have to make it active
    return YES;
}

@end
