//
//  HGPanel.m
//  hourglass
//
//  Created by Matze on 13.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import "HGPanel.h"

@implementation HGPanel

- (BOOL)canBecomeKeyWindow {
    return YES; //allow any field on the panel to become the first responder
}

@end
