//
//  HACContentView.m
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import "HACContentView.h"
#import <QuartzCore/QuartzCore.h>

@interface HACContentView ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation HACContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)setup
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [UIColor orangeColor];
    
    CGRect labelRect = CGRectInset(self.frame, 5.0f, 5.0f);
    _contentLabel = [[UILabel alloc] initWithFrame:labelRect];
    _contentLabel.center = self.center;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    [self addSubview:_contentLabel];
    
    [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.contentLabel.frame = (CGRect) {CGPointZero, self.frame.size};
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setContentText:(NSString *)text
{
    _contentLabel.text = text;
}

- (void)setContentColor:(UIColor *)color
{
    self.backgroundColor = color;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
