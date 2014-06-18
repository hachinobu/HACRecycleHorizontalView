//
//  HACContentObject.m
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import "HACContentObject.h"

@interface HACContentObject ()

@property (nonatomic, strong) NSIndexPath *contentIndexPath;
@property (nonatomic, strong, readwrite) NSDictionary *contentsDic;

@end

@implementation HACContentObject

- (void)createContentsWithIndexPath:(NSIndexPath *)indexPath
{
    self.contentIndexPath = indexPath;
    NSMutableDictionary *contentsDic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < _contentIndexPath.section; i++) {
        NSMutableArray *contents = [NSMutableArray array];
        for (NSInteger j = 0; j < _contentIndexPath.row; j++) {
            NSString *content = [NSString stringWithFormat:@"%ld - %ld", i + 1, j + 1];
            [contents addObject:content];
        }
        contentsDic[@(i)] = contents;
    }
    
    self.contentsDic = [contentsDic copy];
}

- (NSUInteger)frameCount
{
    return _contentIndexPath.section;
}

- (NSUInteger)contentCount
{
    return _contentIndexPath.row;
}

@end
