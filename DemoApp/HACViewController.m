//
//  HACViewController.m
//  HACRecycleScrollViews
//
//  Created by hachinobu on 2014/05/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import "HACViewController.h"
#import "HACContentObject.h"
#import "HACRecycleHorizontalView.h"
#import "HACDeviceUtils.h"

@interface HACViewController () <HACRecycleScrollViewDataSource>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) HACContentObject *contentObject;

@end

@implementation HACViewController

#pragma mark - ViewCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGFloat baseViewPointY = .0f;
    CGRect baseViewRect = [UIScreen mainScreen].bounds;
    if ([HACDeviceUtils isIOS7]) {
        baseViewPointY = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        baseViewRect = [UIScreen mainScreen].applicationFrame;
    }
    baseViewRect.origin.y = baseViewPointY;
    _baseView = [[UIView alloc] initWithFrame:baseViewRect];
    [self.view addSubview:_baseView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentObject = [[HACContentObject alloc] init];
    [_contentObject createContentsWithIndexPath:[NSIndexPath indexPathForRow:10 inSection:100]];
    HACRecycleHorizontalView *recycleView = [[HACRecycleHorizontalView alloc] initWithFrame:self.view.frame];
    recycleView.dataSource = self;
    [self.baseView addSubview:recycleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HACRecycleScrollViewDataSource
- (NSUInteger)frameCount
{
    return [_contentObject frameCount];
}

- (NSUInteger)contentCount
{
    return [_contentObject contentCount];
}

- (NSArray *)contentsWithFrameNumber:(NSNumber *)num
{
    return _contentObject.contentsDic[num];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
