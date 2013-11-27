//
//  HGTask.m
//  hourglass
//
//  Created by Matze on 03.11.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import "HGTask.h"

@implementation HGTask

@synthesize tasklabel;

-(id) init {
    if(self = [super init]) {
        tasklabel = @"tasklabel";
    }
    return self;
}

@end
