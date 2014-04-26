//
//  StatusItemView.h
//  hourglass
//
//  Created by Matze on 25/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenubarController.h"

@interface StatusItemView : NSView

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong, readwrite) NSString *statusContent;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, readonly) NSRect globalRect;

//TODO: Property mit Fetch ersetzen und Status abfragen anstelle ihn zu setzen
@property (nonatomic, setter = setHighlighted:) BOOL isHighlighted;
@property (nonatomic, setter = setTiming:) BOOL isTiming;

- (id)initWithStatusItem:(NSStatusItem *)statusItem;

@end
