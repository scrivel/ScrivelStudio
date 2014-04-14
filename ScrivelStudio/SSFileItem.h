//
//  SSFileItem.h
//  ScrivelStudio
//
//  Created by keroxp on 2014/04/14.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSFileItem : NSObject

- (instancetype)initWithPath:(NSString*)path index:(NSUInteger)index parent:(SSFileItem*)parent;

@property (nonatomic, readonly) SSFileItem *parent;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSUInteger index;

- (NSString*)title;
- (NSIndexPath*)indexPath;
- (NSURL*)url;
- (NSArray*)children;
- (BOOL)isLeaf;
- (NSUInteger)numberOfChildren;

@end
