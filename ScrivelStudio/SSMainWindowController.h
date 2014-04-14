//
//  SSMainWindowController.h
//  ScrivelStudio
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSMainWindowController : NSWindowController<NSOutlineViewDelegate>

@property (nonatomic) NSURL *directoryURL;
@property (nonatomic, readonly) NSArray * directoryContents;
@property (nonatomic) NSArray * selectedItems;
@property (nonatomic) NSArray * selectedIndexPaths;
@property (nonatomic, readonly) NSArray * sortDescriptors;

@end
