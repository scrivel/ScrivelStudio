//
//  SSSceneWindowController.m
//  ScrivelStudio
//
//  Created by keroxp on 2014/04/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SSSceneWindowController.h"

@interface SSSceneWindowController ()
@property (strong) IBOutlet NSDrawer *drawer;
@property (weak) IBOutlet NSView *sceneContentView;

@end

@implementation SSSceneWindowController

@synthesize engine = _engine;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Setter

- (void)setEngine:(ScrivelEngine *)engine
{
    engine.window = self.window;
    engine.rootView = self.sceneContentView;
    _engine = engine;
}

#pragma mark - Action

- (IBAction)onOpen:(id)sender {
    switch (self.drawer.state) {
        case NSDrawerClosedState:
            [self.drawer openOnEdge:NSMinXEdge];
            break;
        case NSDrawerOpenState:
            [self.drawer close];
            break;
        default:
            break;
    }
}

@end
