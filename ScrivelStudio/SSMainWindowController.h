//
//  SSMainWindowController.h
//  ScrivelStudio
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <MGSFragaria.h>
#import "VDKQueue.h"
#import "SSSceneWindowController.h"
#import <ScrivelEngine.h>

typedef NS_ENUM(NSInteger, SegmentType){
    SegmentTypeScriptEditor = 0,
    SegmentTypeGraphicalEditor = 1
};

@interface SSMainWindowController : NSWindowController
<NSOutlineViewDelegate
,NSOutlineViewDataSource
,MGSFragariaTextViewDelegate
,NSTextDelegate
,VDKQueueDelegate
,NSWindowDelegate>

@property (nonatomic) SSSceneWindowController *sceneWindowController;
@property (nonatomic) NSURL *directoryURL;
@property (nonatomic) NSString * filePath;
@property (nonatomic) NSString * fileTitle;
@property (nonatomic, readonly) NSArray * directoryContents;
@property (nonatomic) NSArray * selectedItems;
@property (nonatomic) NSArray * selectedIndexPaths;
@property (nonatomic, readonly) NSArray * sortDescriptors;
@property (nonatomic) BOOL fileSelected;
@property (nonatomic) BOOL fileEditted;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) BOOL canMakeSequencize;

@end
