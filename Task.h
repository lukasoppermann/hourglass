//
//  Task.h
//  hourglass
//
//  Created by Matze on 21/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * budget;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSNumber * isTiming;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSSet *subtask;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addSubtaskObject:(NSManagedObject *)value;
- (void)removeSubtaskObject:(NSManagedObject *)value;
- (void)addSubtask:(NSSet *)values;
- (void)removeSubtask:(NSSet *)values;

@end
