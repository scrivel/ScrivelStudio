//
//  SSFileItem.m
//  ScrivelStudio
//
//  Created by keroxp on 2014/04/14.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SSFileItem.h"

@implementation SSFileItem
{
    NSDictionary *_fileAttribtues;
}
- (instancetype)initWithPath:(NSString *)path index:(NSUInteger)index parent:(SSFileItem *)parent
{
    self = [super init];
    NSError *e = nil;
    _fileAttribtues = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&e];
    _path = path;
    _parent = parent;
    _index = index;
    return self;
}

- (NSArray *)children
{
    NSMutableArray *ma = @[].mutableCopy;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *e = nil;
    NSArray *contents = [fm contentsOfDirectoryAtURL:self.url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&e];
    NSAssert(!e, @"");
    [contents enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop) {
        NSString *path = [self.path stringByAppendingPathComponent:obj.lastPathComponent];
        NSAssert(path, @"");
        SSFileItem *item = [[SSFileItem alloc] initWithPath:path index:idx parent:self];
        [ma addObject:item];
    }];
    return ma;
}

- (BOOL)isLeaf
{
    return ![[_fileAttribtues objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory];
}

- (NSString *)title
{
    return self.path.lastPathComponent;
}

- (NSURL *)url
{
    return [NSURL URLWithString:[_path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSUInteger)numberOfChildren
{
    NSUInteger i = self.children.count;
    return i;
}

- (NSIndexPath *)indexPath
{
    if (_parent) {
        return [_parent.indexPath indexPathByAddingIndex:self.index];
    }else{
        return [NSIndexPath indexPathWithIndex:0];
    }
}

@end
