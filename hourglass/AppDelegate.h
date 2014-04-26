//
//  AppDelegate.h
//  hourglass
//
//  Created by Matze on 21/04/14.
//  Copyright (c) 2014 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenubarController.h"
#import "UIController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, UIControllerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readwrite, strong, nonatomic) MenubarController *menuBarController;
@property (nonatomic, strong, readonly) UIController *UIController;

- (IBAction)saveAction:(id)sender;
- (IBAction)togglePanel:(id)sender;

#pragma WindowController Methods
- (BOOL)isEditing;

@end
