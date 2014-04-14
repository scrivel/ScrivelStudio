//
//  SSAppDelegate.m
//  ScrivelStudio
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SSAppDelegate.h"

@implementation SSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)onOpen:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setTitle:NSLocalizedString(@"フォルダーを選択", )];
    [op setCanChooseDirectories:YES];
    [op setCanChooseFiles:NO];
    [op setCanCreateDirectories:YES];
    switch ([op runModal]) {
        case NSFileHandlingPanelOKButton: {
            NSLog(@"%@",op.URLs);
            SSMainWindowController *mwc = [[SSMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
            [mwc setDirectoryURL:op.URL];
            [mwc showWindow:self];
            self.mainWindowController = mwc;

        }
            break;
        default:
            break;
    }
}

@end
