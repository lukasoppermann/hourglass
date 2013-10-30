//
//  HGStatusItemView.h
//  hourglass
//
//  Created by Matze on 13.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HGStatusItemView : NSView

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, readonly) NSRect globalRect;
@property (nonatomic, setter = setHighlighted:) BOOL isHighlighted;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;

- (id)initWithStatusItem:(NSStatusItem *)statusItem;

@end
