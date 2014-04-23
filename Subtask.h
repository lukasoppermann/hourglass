//
//  Subtask.h
//  hourglass
//
//  Created by Matze on 21/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Subtask : NSManagedObject

@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Task *parentTask;

@end
