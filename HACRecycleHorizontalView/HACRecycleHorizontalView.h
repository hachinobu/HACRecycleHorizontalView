//
//  HACRecycleScrollView.h
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HACContentObject;
@protocol HACRecycleScrollViewDataSource;

@interface HACRecycleHorizontalView : UIScrollView

@property (nonatomic, weak) NSObject<HACRecycleScrollViewDataSource> *dataSource;

@end

@protocol HACRecycleScrollViewDataSource <NSObject>

- (NSUInteger)frameCount;
- (NSArray *)contentsWithFrameNumber:(NSNumber *)num;

@end