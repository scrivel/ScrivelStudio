//
//  SSMainWindowController.h
//  ScrivelStudio
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MGSFragaria.h>

@interface SSMainWindowController : NSWindowController<NSOutlineViewDelegate, MGSFragariaTextViewDelegate, NSTextDelegate>

@property (nonatomic) NSURL *directoryURL;
@property (nonatomic) NSString * filePath;
@property (nonatomic) NSString * fileTitle;
@property (nonatomic, readonly) NSArray * directoryContents;
@property (nonatomic) NSArray * selectedItems;
@property (nonatomic) NSArray * selectedIndexPaths;
@property (nonatomic, readonly) NSArray * sortDescriptors;
@property (nonatomic) BOOL fileEditted;

@end
