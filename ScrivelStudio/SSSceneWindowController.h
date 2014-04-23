//
//  SSSceneWindowController.h
//  ScrivelStudio
//
//  Created by keroxp on 2014/04/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ScrivelEngine.h>

@interface SSSceneWindowController : NSWindowController

@property (nonatomic, weak) ScrivelEngine *engine;
@property (nonatomic, copy) NSURL *projectURL;

@end
