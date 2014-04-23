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
#import <NSObject+KXEventEmitter.h>
#import <ScrivelEngine/SEScript.h>

#define kRowHeight 16
#define kFolderIconKey @"org.scrivel.ScrivelStudio:kFolderIconKey"
@interface SSMainWindowController ()
{
    SSFileItem *_rootItem;
    MGSFragaria *_fragaria;
    ScrivelEngine *_engine;
    VDKQueue *_watcher;
    SEScript *_script;
    NSMutableArray *__selectedItems;
    NSMutableArray *__selectedIndexPaths;
    NSMutableDictionary *_iconsForFileType;
    NSMutableDictionary *_expandedTreeNodes;
}

@property (strong) IBOutlet NSTreeController *fileTreeController;
@property (weak) IBOutlet NSOutlineView *fileOutlineView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSOutlineView *sequenceOutlineView;
@property (weak) IBOutlet NSView *scriptEditorView;
@property (weak) IBOutlet NSScrollView *sequenceContainerView;
@property (weak) IBOutlet NSSegmentedControl *segmentedControl;

- (NSTextView*)textView;

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
        VDKQueue *vdk = [VDKQueue new];
        vdk.delegate = self;
        _watcher = vdk;
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
    [fragaria embedInView:self.scriptEditorView];
    _fragaria = fragaria;
    
    // setup segment
    self.sequenceContainerView.hidden = YES;    
    
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
    [self.fileTreeController rearrangeObjects];
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

#pragma mark - Setter

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

#pragma mark - Outline View Data Source

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSAssert(outlineView == self.sequenceOutlineView, @"fileOutLineViewはバインドしてあるからこない");
    NSAssert(_script, @"SEScriptファイルでないときはビューを開かせない");
    if (!item) {
        return [_script elements][index];
    }else if ([item isKindOfClass:[SEMethodChain class]]){
        return [(SEMethodChain*)item methods][index];
    }
    NSAssert(NO, @"こない");
    return nil;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSAssert(outlineView == self.sequenceOutlineView, @"fileOutLineViewはバインドしてあるからこない");
    if (!item) {
        return _script.elements.count;
    }else if([item isKindOfClass:[SEMethodChain class]]){
        NSAssert([item isKindOfClass:[SEMethodChain class]], @"");
        return [[(SEMethodChain*)item methods] count];
    }
    NSAssert(NO, @"こない");
    return -1;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    NSAssert(outlineView == self.sequenceOutlineView, @"fileOutLineViewはバインドしてあるからこない");
    if (!item) {
        return YES;
    }else if ([item isKindOfClass:[SEMethodChain class]]) {
        return YES;
    }else if ([item isKindOfClass:[SEWords class]]){
        return NO;
    }
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    NSAssert(outlineView == self.sequenceOutlineView, @"fileOutLineViewはバインドしてあるからこない");
    if ([tableColumn.identifier isEqualToString:@"TypeColumn"]) {
        if (!item) {
            return @"Script";
        }else if ([item isKindOfClass:[SEMethodChain class]]) {
            return @"MethodChain";
        }else if ([item isKindOfClass:[SEWords class]]) {
            return @"Words";
        }else if ([item isKindOfClass:[SEMethod class]]) {
            return @"Method";
        }
    }else if ([tableColumn.identifier isEqualToString:@"DescriptionColumn"]){
        return [item description];
    }
    NSAssert(NO, @"来ない");
    return nil;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    NSAssert(outlineView == self.sequenceOutlineView, @"fileOutLineViewはバインドしてあるからこない");
}


#pragma mark - Outline View Delegate

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSOutlineView *outlineView = notification.object;
    NSAssert(outlineView, @"");
    if (outlineView == self.fileOutlineView) {
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
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
    NSOutlineView *outlineView = notification.object;
    NSAssert(outlineView, @"");
    if (outlineView == self.fileOutlineView) {
        NSTreeNode *obj = notification.userInfo[@"NSObject"];
        NSLog(@"%@",notification.object);
        SSFileItem *item = [obj representedObject];
        NSAssert(item, @"");
        [_watcher addPath:item.path];
        [_expandedTreeNodes setObject:obj forKey:item.path];
        NSLog(@"%s,%@",__PRETTY_FUNCTION__,notification.userInfo);
    }
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
    NSOutlineView *outlineView = notification.object;
    NSAssert(outlineView, @"");
    if (outlineView == self.fileOutlineView) {
        NSTreeNode *obj = notification.userInfo[@"NSObject"];
        SSFileItem *item = [obj representedObject];
        NSAssert(item, @"");
        [_watcher removePath:item.path];
        [_expandedTreeNodes removeObjectForKey:item.path];
        NSLog(@"%s,%@",__PRETTY_FUNCTION__,notification.userInfo);
    }
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
            // .sescriptの場合のみシーケンスエディタへ移動できる
            self.canMakeSequencize = [item.path.pathExtension isEqualToString:@"sescript"];
            // fragariaに文字列をセット
            [_fragaria setString:str];
        }
        self.fileEditted = NO;
        [self.segmentedControl setSelectedSegment:SegmentTypeScriptEditor];
        [self onSegmentChanged:self.segmentedControl];
        _selectedItems = selectedItems;
    }
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)tableColumn item:(id)anItem
{
    if (outlineView == self.fileOutlineView) {
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
            break;
        default:
            break;
    }
}
- (IBAction)onClear:(id)sender {
    [_engine clear];
}

- (IBAction)onSegmentChanged:(NSSegmentedControl*)sender {
    switch(sender.selectedSegment){
        case SegmentTypeScriptEditor: {
            self.scriptEditorView.hidden = NO;
            self.sequenceContainerView.hidden = YES;
        }
            break;
        case SegmentTypeGraphicalEditor: {
            // textViewの文字列からSEScriptオブジェクトを作る
            NSError *e = nil;
            SEScript *s = nil;
            void (^onError)(id) = ^(id error){
                if ([error isKindOfClass:[NSException class]]) {
                    [[NSAlert alertWithMessageText:[(NSException*)error description]
                                    defaultButton:@"OK"
                                  alternateButton:nil
                                      otherButton:nil
                        informativeTextWithFormat:nil] runModal];
                }else if ([error isKindOfClass:[NSError class]]){
                    [[NSAlert alertWithError:e] runModal];
                }
                [sender setSelectedSegment:SegmentTypeScriptEditor];
            };
            @try {
                s = [SEScript scriptWithString:self.textView.string error:&e];
                if (e) {
                    onError(e);
                    return;
                }
                _script = s;
                [self.sequenceOutlineView reloadData];
                self.sequenceContainerView.hidden = NO;
                self.scriptEditorView.hidden = YES;
            }
            @catch (NSException *exception) {
                onError(e);
                return;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Scene Window Delegate

- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"%s %@",__PRETTY_FUNCTION__,notification.userInfo);
    self.sceneWindowController = nil;
}

@end
