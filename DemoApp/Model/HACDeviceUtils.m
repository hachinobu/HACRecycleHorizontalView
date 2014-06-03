//
//  HACDeviceUtils.m
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/30.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import "HACDeviceUtils.h"

@implementation HACDeviceUtils

+ (BOOL)isIOS7
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    NSArray *nums = [version componentsSeparatedByString:@"."];
    return [[nums firstObject] integerValue] >= 7;
}

@end
