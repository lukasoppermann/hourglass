////
////  HGTableViewController.m
////  hourglass
////
////  Created by Matze on 03.11.13.
////  Copyright (c) 2013 hourglass. All rights reserved.
////
//
//#import "HGTableViewController.h"
//#import "HGTask.h"
//
//@implementation HGTableViewController
//
//-(void)windowDidLoad {
//    [super windowDidLoad];
//    
//}
//
//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
//    return [tasks count];
//}
//
//- (NSView *)tableView:(NSTableView *)tableView
//   viewForTableColumn:(NSTableColumn *)tableColumn
//                  row:(NSInteger)row {
//    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
//    cellView.textField.stringValue = [[tasks objectAtIndex:row] tasklabel];
//
//    return cellView;
//}
//
//- (void)tableView:(NSTableView *)tableView
//   setObjectValue:(id)object
//   forTableColumn:(NSTableColumn *)tableColumn
//              row:(NSInteger)row {
//    HGTask *task = [tasks objectAtIndex:row];
//    NSString *identifier = [tableColumn identifier];
//    [task setValue:object forKey:identifier];
//}
//
//    
//- (IBAction)buttonAdd:(id)sender {
//    if (tasks == nil) {
//        tasks = [NSMutableArray new];
//    }
//    [tasks addObject:[[HGTask alloc] init]];
//    [HGTableView reloadData];
//}
//
//- (IBAction)buttonDelete:(id)sender {
//    NSInteger row = [HGTableView rowForView:sender];
//    [HGTableView abortEditing];
//    if (row != -1)
//        [tasks removeObjectAtIndex:row];
//    [HGTableView reloadData];
//}
//
//@end
