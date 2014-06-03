//
//  HACContentView.h
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HACContentView : UIView

- (void)setContentText:(NSString *)text;
- (void)setContentColor:(UIColor *)color;

@property (strong, nonatomic) NSString *identifier;

@end
