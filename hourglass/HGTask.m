//
//  HGTask.m
//  hourglass
//
//  Created by Matze on 03.11.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import "HGTask.h"

@implementation HGTask

-(id) init {
    if(self = [super init]) {
        _tasklabel = @"hourglass Task";
        _totalTime = @"--:--";
        _TimingSessions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startTimer {
        if ([_totalTime  isEqual: @"--:--"])
        [self setTotalTime:@"00:00"];
    
        MinuteTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                          target:self
                                                        selector:@selector(addMinute:)
                                                        userInfo:nil
                                                         repeats:YES];
    
}

-(void) addMinute:(NSTimer *)timer {
    NSNumber* SixtyWrapped = [NSNumber numberWithInt:60];
    
    [_TimingSessions addObject:SixtyWrapped];
    [self updateTotalTime];

}

-(void)stopTimer {
    [MinuteTimer invalidate];
    
    [self updateTotalTime];
}

-(void)updateTotalTime {
    NSInteger sum = 0;
    for (NSNumber *num in _TimingSessions)
    {
        sum += [num intValue];
    }
    
    int seconds = (sum) % 60;
    int minutes = ((sum - seconds) / 60) % 60;
    int hours = (int)(sum - seconds - 60 * minutes) / 3600;
    
    [self setTotalTime:[NSString stringWithFormat:@"%.2d:%.2d", hours,
                        minutes]];
}

-(BOOL) hasActiveTimer {
    return [MinuteTimer isValid];
}

@end
