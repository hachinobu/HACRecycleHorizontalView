//
//  HACNumberView.m
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import "HACFrameView.h"

@interface HACFrameView ()

@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation HACFrameView

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
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numberLabel.backgroundColor = [UIColor blackColor];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self addSubview:_numberLabel];
    
    [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.numberLabel.frame = (CGRect) {CGPointZero, self.frame.size};
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setNumberText:(NSString *)text
{
    _numberLabel.text = text;
}

- (NSString *)numberText
{
    return _numberLabel.text;
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
