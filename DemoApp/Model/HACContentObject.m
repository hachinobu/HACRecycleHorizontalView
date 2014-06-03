//
//  HACContentObject.m
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import "HACContentObject.h"

@interface HACContentObject ()

@property (nonatomic, strong, readwrite) NSDictionary *contentsDic;

@end

@implementation HACContentObject

- (instancetype)initWithIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        _contentsDic = [self setupContentsDicWithIndex:index];
    }
    return self;
}

- (NSDictionary *)setupContentsDicWithIndex:(NSInteger)idx
{
    NSMutableDictionary *contentsDic = [NSMutableDictionary dictionaryWithCapacity:idx];
    for (NSInteger i = 0; i < idx; i++) {
        NSMutableArray *contents = [NSMutableArray array];
        for (NSInteger j = 0; j < 6; j++) {
            NSString *content = [NSString stringWithFormat:@"%ld - %ld", i + 1, j+ 1];
            [contents addObject:content];
        }
        contentsDic[@(i)] = contents;
    }
    
    return [contentsDic copy];
}

@end
