//
//  HACContentObject.h
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HACContentObject : NSObject

@property (nonatomic, strong, readonly) NSDictionary *contentsDic;

- (instancetype)initWithIndex:(NSUInteger)index;

@end
