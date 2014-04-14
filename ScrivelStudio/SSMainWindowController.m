//
//  SSMainWindowController.m
//  ScrivelStudio
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SSMainWindowController.h"
#import "SSFileItem.h"
#import "ImageAndTextCell.h"

#define kRowHeight 16
#define kFolderIconKey @"me.keroxp.app.ScrivelStudio:kFolderIconKey"

@interface SSMainWindowController ()
{
    SSFileItem *_rootItem;
    NSMutableArray *__selectedItems;
    NSMutableArray *__selectedIndexPaths;
    NSMutableDictionary *_iconsForFileType;
}
@property (weak) IBOutlet NSOutlineView *fileOutlineView;
@property (weak) IBOutlet NSView *contentView;

@end

@implementation SSMainWindowController
@synthesize selectedIndexPaths = __selectedIndexPaths;
@synthesize selectedItems = _selectedItems;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
        __selectedIndexPaths = [NSMutableArray new];
        __selectedItems = [NSMutableArray new];
        _iconsForFileType = [NSMutableDictionary new];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // setup image cell
    NSTableColumn *tableColumn = [self.fileOutlineView tableColumnWithIdentifier:@"FirstColumn"];
	ImageAndTextCell *imageAndTextCell = [[ImageAndTextCell alloc] init];
	[imageAndTextCell setEditable:YES];
    [imageAndTextCell setLineBreakMode:NSLineBreakByTruncatingTail];
	[tableColumn setDataCell:imageAndTextCell];
    
    // setup delegate & data source
    self.fileOutlineView.delegate = self;
    self.fileOutlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
    
    // setupfragaria
    MGSFragaria *fragaria = [MGSFragaria new];
    [fragaria setObject:self forKey:MGSFODelegate];
    [fragaria embedInView:self.contentView];
}

#pragma mark - 

- (void)textDidBeginEditing:(NSNotification *)notification
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)textDidChange:(NSNotification *)notification
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark -

- (void)setDirectoryURL:(NSURL *)directoryURL
{
    _rootItem = [[SSFileItem alloc] initWithPath:directoryURL.path index:0 parent:nil];
    _directoryURL = directoryURL;
}

- (NSArray *)directoryContents
{
    return @[_rootItem];
}

#pragma mark - outline

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"selection change : %@", self.selectedIndexPaths);
    NSInteger i = self.fileOutlineView.selectedRow;
    NSTreeNode *treeNode = [self.fileOutlineView itemAtRow:i];
    SSFileItem *item = treeNode.representedObject;
    self.filePath = item.path;
    self.fileTitle = item.title;
}

- (void)outlineView:(NSOutlineView *)outlineView didClickTableColumn:(NSTableColumn *)tableColumn
{
    NSLog(@"did click column : %@", tableColumn);
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)tableColumn item:(id)anItem
{
    if ([aCell isKindOfClass:[ImageAndTextCell class]]) {
        // icon
        ImageAndTextCell *imageCell = (ImageAndTextCell*)aCell;
        SSFileItem *item = [anItem representedObject];
        NSString *ext = item.path.pathExtension;
        NSImage *image;
        static NSSize imageSize = (NSSize){kRowHeight,kRowHeight};
        if (item.isLeaf) {
            image = _iconsForFileType[ext];
            if (!image) {
                image = [[NSWorkspace sharedWorkspace] iconForFileType:ext];
                if (image) {
                    [image setSize:imageSize];
                    [_iconsForFileType setObject:image forKey:ext];
                }
            }
        }else{
            image = _iconsForFileType[kFolderIconKey];
            if (!image) {
                // folder
                image = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
                [image setSize:imageSize];
                [_iconsForFileType setObject:image forKey:kFolderIconKey];
            }
        }
        if (image) {
            [imageCell setImage:image];
        }
    }
}

@end
