//
//  HACRecycleScrollView.m
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import "HACRecycleHorizontalView.h"
#import "HACContentObject.h"
#import "HACFrameView.h"
#import "HACContentView.h"

static CGFloat const HACFrameViewHeight = 40.0f;
static CGFloat const HACOneContentWidth = 80.0f;
static CGFloat const HACMarginTop = 12.0f;
static CGFloat const HACContentViewHeight = 70.0f;

@interface HACRecycleHorizontalView () <UIScrollViewDelegate>
{
    NSInteger frameCount;
    NSRange displayRange;
    CGFloat beforeOffsetX;
}

@property (nonatomic, strong) NSMutableArray *displayFrameViews;
@property (nonatomic, strong) NSMutableArray *displayContentViews;
@property (nonatomic, strong) NSMutableSet *reusableFrameViews;
@property (nonatomic, strong) NSMutableSet *reusableContentViews;
@property (nonatomic, strong) NSPredicate *frameViewPredicateTemplate;
@property (nonatomic, strong) NSPredicate *contentViewPredicateTemplate;

@end

@implementation HACRecycleHorizontalView

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)superview
{
    if (superview) {
        [self reloadData];
    }
}

- (void)initialSetup
{
    self.bounces = NO;
    self.delegate = self;
    self.backgroundColor = [UIColor lightGrayColor];
    _frameViewPredicateTemplate = [NSPredicate predicateWithFormat:@"$numberText == numberText"];
    _contentViewPredicateTemplate = [NSPredicate predicateWithFormat:@"$identifier == identifier"];
    beforeOffsetX = 0;
}

- (NSInteger)contentFrameCount
{
    if ([_dataSource respondsToSelector:@selector(frameCount)]) {
        return [_dataSource frameCount];
    }
    return 0;
}

- (NSArray *)contentsWithFrameNumber:(NSNumber *)num
{
    if ([_dataSource respondsToSelector:@selector(contentsWithFrameNumber:)]) {
        return [_dataSource contentsWithFrameNumber:num];
    }
    return nil;
}

- (void)clearData
{
    for (UIView *view in _displayFrameViews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in _displayContentViews) {
        [view removeFromSuperview];
    }
}

- (void)reloadData
{
    [self clearData];
    
    self.displayFrameViews = [NSMutableArray array];
    self.displayContentViews = [NSMutableArray array];
    self.reusableFrameViews = [NSMutableSet set];
    self.reusableContentViews = [NSMutableSet set];
    
    frameCount = [self contentFrameCount];
    self.contentSize = CGSizeMake(frameCount * HACOneContentWidth, CGRectGetHeight(self.frame));
    
    for (NSInteger i = 0; i < frameCount; i++) {
        [self makeViewWithNumber:i isHead:NO];
        HACFrameView *lastFrameView = [_displayFrameViews lastObject];
        if (CGRectGetMaxX(lastFrameView.frame) >= CGRectGetWidth(self.frame)) {
            displayRange = NSMakeRange(0lu, i + 1);
            break;
        }
    }
}

- (void)makeViewWithNumber:(NSInteger)num isHead:(BOOL)isHead
{
    HACFrameView *frameView = [self frameViewWithNumber:num];
    NSArray *result = [_displayFrameViews filteredArrayUsingPredicate:[_frameViewPredicateTemplate predicateWithSubstitutionVariables:@{@"numberText": [frameView numberText]}]];
    if ([result count] > 0) {
        return;
    }
    
    if (isHead) {
        [_displayFrameViews insertObject:frameView atIndex:0];
    } else {
        [_displayFrameViews addObject:frameView];
    }
    [self addSubview:frameView];
    
    NSArray *contents = [self contentsWithFrameNumber:@(num)];
    [contents enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
        HACContentView *contentView = [self contentViewWithNumber:num text:text];
        CGFloat pointY;
        if (idx == 0) {
            pointY = HACFrameViewHeight + HACMarginTop;
        } else {
            HACContentView *beforeContentView = isHead ? [_displayContentViews firstObject] : [_displayContentViews lastObject];
            pointY = CGRectGetMaxY(beforeContentView.frame) + HACMarginTop;
        }
        contentView.frame = CGRectMake(num * HACOneContentWidth, pointY, HACOneContentWidth, HACContentViewHeight);
        
        if (isHead) {
            [_displayContentViews insertObject:contentView atIndex:0];
        } else {
            [_displayContentViews addObject:contentView];
        }
        [self addSubview:contentView];
    }];
    
}

#pragma mark - FrameView Cycle
- (HACFrameView *)frameViewWithNumber:(NSInteger)num
{
    HACFrameView *frameView = [self reusableFrameView];
    if (!frameView) {
        frameView = [[HACFrameView alloc] initWithFrame:CGRectZero];
    }
    frameView.frame = CGRectMake(num * HACOneContentWidth, .0f, HACOneContentWidth, HACFrameViewHeight);
    [frameView setNumberText:[NSString stringWithFormat:@"%ld", (num + 1)]];
    
    return frameView;
}

- (HACFrameView *)reusableFrameView
{
    if (_reusableFrameViews && [_reusableFrameViews count] > 0) {
        HACFrameView *reusableFrameView = [_reusableFrameViews anyObject];
        [_reusableFrameViews removeObject:reusableFrameView];
        return reusableFrameView;
    }
    return nil;
}

#pragma mark - ContentView Cycle
- (HACContentView *)contentViewWithNumber:(NSInteger)num text:(NSString *)text
{
    HACContentView *contentView = [self reusableContentView];
    if (!contentView) {
        contentView = [[HACContentView alloc] initWithFrame:CGRectZero];
    }
    
    contentView.identifier = [NSString stringWithFormat:@"%ld", (num + 1)];
    [contentView setContentText:text];
    return contentView;
}

- (HACContentView *)reusableContentView
{
    if (_reusableContentViews && [_reusableContentViews count] > 0) {
        HACContentView *reusableView = [_reusableContentViews anyObject];
        [_reusableContentViews removeObject:reusableView];
        return reusableView;
    }
    return nil;
}

#pragma mark - Reusable
//表示領域外のViewを削除して再利用可能にする
- (void)reusableSettingOutSideDisplayView
{
    NSRange currentRange = NSMakeRange(self.contentOffset.x, CGRectGetWidth(self.frame));
    NSMutableArray *reusableFrameViews = [NSMutableArray array];
    NSMutableArray *reusableContentViews = [NSMutableArray array];

    [_displayFrameViews enumerateObjectsUsingBlock:^(HACFrameView *frameView, NSUInteger idx, BOOL *stop) {
        if (CGRectGetMaxX(frameView.frame) <= currentRange.location ||
            CGRectGetMinX(frameView.frame) >= currentRange.location + currentRange.length) {
            
            [frameView removeFromSuperview];
            [reusableFrameViews addObject:frameView];
            NSArray *contentViews = [_displayContentViews filteredArrayUsingPredicate:[_contentViewPredicateTemplate predicateWithSubstitutionVariables:@{@"identifier": [frameView numberText]}]];
            [reusableContentViews addObjectsFromArray:contentViews];
            for (HACContentView *contentView in contentViews) {
                [contentView removeFromSuperview];
            }
            
        }
    }];
    
    [_reusableFrameViews addObjectsFromArray:reusableFrameViews];
    [_displayFrameViews removeObjectsInArray:reusableFrameViews];
    
    [_reusableContentViews addObjectsFromArray:reusableContentViews];
    [_displayContentViews removeObjectsInArray:reusableContentViews];
}

#pragma mark - ScrollEvent
- (void)rightScrollAction
{
    NSInteger currentDisplayLastNumber = displayRange.location + displayRange.length;
    NSInteger needDisplayNumber = (self.contentOffset.x + CGRectGetWidth(self.frame)) / HACOneContentWidth;
    if (currentDisplayLastNumber >= needDisplayNumber) {
        return;
    }
    for (NSInteger i = currentDisplayLastNumber; i <= needDisplayNumber; i++) {
        [self makeViewWithNumber:i isHead:NO];
    }
}

- (void)leftScrollAction
{
    NSInteger currentDisplayFirstNumber = displayRange.location;
    NSInteger needDisplayNumber = self.contentOffset.x / HACOneContentWidth;
    if (currentDisplayFirstNumber <= needDisplayNumber) {
        return;
    }
    for (NSInteger i = currentDisplayFirstNumber; i >= needDisplayNumber; i--) {
        [self makeViewWithNumber:i isHead:YES];
    }
}

- (void)refreshDisplayRange
{
    HACFrameView *displayFirstView = [_displayFrameViews firstObject];
    HACFrameView *displayLastView = [_displayFrameViews lastObject];
    NSInteger location = CGRectGetMinX(displayFirstView.frame) / HACOneContentWidth;
    NSInteger length = CGRectGetMinX(displayLastView.frame) / HACOneContentWidth - location;
    displayRange = NSMakeRange(location, length);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.contentOffset.x <= 0) {
        self.contentOffset = CGPointZero;
    }
    else if (self.contentOffset.x + CGRectGetWidth(self.frame) >= HACOneContentWidth * frameCount) {
        CGFloat lastPointX = scrollView.contentSize.width - CGRectGetWidth(self.frame) + 1.0f;
        self.contentOffset = CGPointMake(lastPointX, .0f);
    }
    
    [self reusableSettingOutSideDisplayView];
    
    //右スクロール
    if (self.contentOffset.x > beforeOffsetX) {
        [self rightScrollAction];
    }
    //左スクロール
    else if (self.contentOffset.x < beforeOffsetX) {
        [self leftScrollAction];
    }
    
    [self refreshDisplayRange];
    beforeOffsetX = self.contentOffset.x;
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
