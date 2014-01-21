//
//  HGTask.h
//  hourglass
//
//  Created by Matze on 03.11.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGTask : NSObject {
    NSTimer *MinuteTimer;
}

@property (nonatomic, strong, readwrite) NSString *tasklabel;
@property (nonatomic, strong, readwrite) NSString *totalTime;
@property (nonatomic, strong, readwrite) NSMutableArray *TimingSessions;

-(void) startTimer;
-(void) stopTimer;
-(BOOL) hasActiveTimer;

@end
