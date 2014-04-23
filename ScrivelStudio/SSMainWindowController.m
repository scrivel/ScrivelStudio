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
    MGSFragaria *_fragaria;
    ScrivelEngine *_engine;
    VDKQueue *_watcher;
    NSMutableArray *__selectedItems;
    NSMutableArray *__selectedIndexPaths;
    NSMutableDictionary *_iconsForFileType;
    NSMutableDictionary *_expandedTreeNodes;
}

@property (weak) IBOutlet NSOutlineView *fileOutlineView;
@property (weak) IBOutlet NSView *contentView;
@property (nonatomic, readonly) NSTextView *textView;

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
        _fileEditted = NO;
        _fileSelected = NO;
        _isRunning = YES;
        _watcher = [VDKQueue new];
        _watcher.delegate = self;
        _iconsForFileType = [NSMutableDictionary new];
        _expandedTreeNodes = [NSMutableDictionary new];
        _engine = [ScrivelEngine new];
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
    _fragaria = fragaria;
}

#pragma mark - 

- (void)textDidBeginEditing:(NSNotification *)notification
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.fileEditted = YES;
}

- (void)textDidChange:(NSNotification *)notification
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark - VDKQueue Delegate

- (void)VDKQueue:(VDKQueue *)queue receivedNotification:(NSString *)noteName forPath:(NSString *)fpath
{
    NSLog(@"%s %@, %@",__PRETTY_FUNCTION__, noteName, fpath);
    NSTreeNode *node = _expandedTreeNodes[fpath];
    [self.treeController rearrangeObjects];
    NSAssert(node, @"");
    if ([noteName isEqualToString:VDKQueueWriteNotification]) {
        // 追加
    }else if ([noteName isEqualToString:VDKQueueRenameNotification]){
        // rename
    }else if ([noteName isEqualToString:VDKQueueDeleteNotification]){
        // 削除
    }else if ([noteName isEqualToString:VDKQueueLinkCountChangeNotification]){
        // フォルダ作成？
    }
}

#pragma mark -

- (void)setDirectoryURL:(NSURL *)directoryURL
{
    // ルートアイテムを作る
    _rootItem = [[SSFileItem alloc] initWithPath:directoryURL.path index:0 parent:nil];
    // エンジンのbaseURLを設定
    _engine.baseURL = directoryURL;
    // set
    _directoryURL = directoryURL;
}

- (NSArray *)directoryContents
{
    return @[_rootItem];
}

- (NSTextView *)textView
{
    return [_fragaria objectForKey:ro_MGSFOTextView];
}

#pragma mark - outline

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"selection change : %@", self.selectedIndexPaths);
    NSInteger i = self.fileOutlineView.selectedRow;
    if (i > 0) {
        NSTreeNode *treeNode = [self.fileOutlineView itemAtRow:i];
        SSFileItem *item = treeNode.representedObject;
        self.filePath = item.path;
        self.fileTitle = item.title;
        self.selectedItems = @[item];
        self.fileSelected = YES;
    }else{
        self.filePath = nil;
        self.fileTitle = nil;
        self.selectedItems = @[];        
        self.fileSelected = NO;
    }
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
    NSTreeNode *obj = notification.userInfo[@"NSObject"];
    SSFileItem *item = [obj representedObject];
    NSAssert(item, @"");
    [_watcher addPath:item.path];
    [_expandedTreeNodes setObject:obj forKey:item.path];
    NSLog(@"%s,%@",__PRETTY_FUNCTION__,notification.userInfo);
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
    NSTreeNode *obj = notification.userInfo[@"NSObject"];
    SSFileItem *item = [obj representedObject];
    NSAssert(item, @"");
    [_watcher removePath:item.path];
    [_expandedTreeNodes removeObjectForKey:item.path];
    NSLog(@"%s,%@",__PRETTY_FUNCTION__,notification.userInfo);
}

- (void)setSelectedItems:(NSArray *)selectedItems
{
    if (selectedItems != _selectedItems) {
        SSFileItem *item = [selectedItems firstObject];
        if (item.isLeaf) {
            NSError *e = nil;
            NSData *data = [NSData dataWithContentsOfFile:item.path options:0 error:&e];
            if (e) {
                [NSAlert alertWithError:e];
                return;
            }
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (!str) {
                [NSAlert alertWithMessageText:NSLocalizedString(@"エラー", ) defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"読み込めないファイルです",nil];
                return;
            }
            [_fragaria setString:str];
        }
        self.fileEditted = NO;
        _selectedItems = selectedItems;
    }
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
        if (!_iconsForFileType[kFolderIconKey]) {
            NSImage *folderIcon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
            [folderIcon setSize:imageSize];
            _iconsForFileType[kFolderIconKey] = folderIcon;
        }
        if (ext.length == 0 && !item.isLeaf) {
            ext = kFolderIconKey;
        }
        image = _iconsForFileType[ext];
        if (!image) {
            if (ext.length > 0) {
                // 拡張子があれば取得
                image = [[NSWorkspace sharedWorkspace] iconForFileType:ext];
                [_iconsForFileType setObject:image forKey:ext];
            }else{
                image = [[NSWorkspace sharedWorkspace] iconForFile:item.path];
            }
            [image setSize:imageSize];
        }
        [imageCell setImage:image];
    }
}

#pragma mark - Actions

- (void)showSceneWindow
{
    SSSceneWindowController *swc = [[SSSceneWindowController alloc] initWithWindowNibName:@"SceneWindow"];
    [swc showWindow:self];
    swc.window.delegate = self;
    swc.engine = _engine;
    NSString *script = self.textView.string;
    NSError *e = nil;
    [_engine evaluateScript:script error:&e];
    self.isRunning = YES;
    self.sceneWindowController = swc;
}

- (IBAction)onRun:(id)sender {
    [self showSceneWindow];
}

- (IBAction)onStop:(NSButton*)sender {
    switch (_engine.state) {
        case ScrivelEngineStatePaused: {
            [_engine resume];
        }
            break;
        case ScrivelEngineStateRunning: {
            [_engine pause];
        }
        default:
            break;
    }
}
- (IBAction)onClear:(id)sender {
    [_engine clear];
}

#pragma mark - Scene Window Delegate

- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"%s %@",__PRETTY_FUNCTION__,notification.userInfo);
    self.sceneWindowController = nil;
}

@end
