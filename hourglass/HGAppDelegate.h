//
//  HGAppDelegate.h
//  hourglass
//
//  Created by Matze on 13.10.13.
//  Copyright (c) 2013 hourglass. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HGMenuBarController.h"
#import "HGPanelController.h"

@interface HGAppDelegate : NSObject <NSApplicationDelegate, HGPanelControllerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) HGMenuBarController *menuBarController;
@property (nonatomic, strong, readonly) HGPanelController *panelController;

- (IBAction)saveAction:(id)sender;
- (IBAction)togglePanel:(id)sender;

@end
