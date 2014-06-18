//
//  HACContentObjectTest.m
//  DemoApp
//
//  Created by Takahiro Nishinobu on 2014/06/18.
//  Copyright (c) 2014年 hachinobu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HACContentObject.h"

@interface HACContentObjectTest : XCTestCase

@property (nonatomic, strong) HACContentObject *testObj;

@end

@implementation HACContentObjectTest

- (void)setUp
{
    [super setUp];
    self.testObj = [[HACContentObject alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testCreateContentsWithIndexPathTest
{
    
    XCTAssertNil(_testObj.contentsDic, @"contentsDicが初期化時点でnilでない");
    
    [_testObj createContentsWithIndexPath:[NSIndexPath indexPathForRow:10 inSection:100]];
    XCTAssertNotNil(_testObj.contentsDic, @"contentDicが生成されていない");
    XCTAssertTrue([_testObj.contentsDic count] == 100, @"指定件数分のframeが作成されていない");
    for (NSArray *contents in [_testObj.contentsDic allValues]) {
        XCTAssertNotNil(contents, @"コンテンツが生成されていない");
        XCTAssertTrue([contents count] == 10, @"生成されたコンテンツの件数が指定件数でない");
    }
    
    [_testObj createContentsWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(_testObj.contentsDic, @"contentsDicがnilになっている");
    XCTAssertTrue([_testObj.contentsDic count] == 0, @"フレームの件数が0でない");
    
    [_testObj createContentsWithIndexPath:nil];
    XCTAssertNotNil(_testObj.contentsDic, @"contentsDicがnilになっている");
    XCTAssertTrue([_testObj.contentsDic count] == 0, @"フレームの件数が0でない");
}

- (void)testFrameCount
{
    [_testObj createContentsWithIndexPath:[NSIndexPath indexPathForRow:5 inSection:50]];
    XCTAssertTrue([_testObj frameCount] == [_testObj.contentsDic count], @"指定した件数のフレームが作成されていない");
    
    [_testObj createContentsWithIndexPath:nil];
    XCTAssertTrue([_testObj frameCount] == 0, @"引数にnilを指定した場合にフレーム件数が0になっていない");
}

- (void)testContentCount
{
    [_testObj createContentsWithIndexPath:[NSIndexPath indexPathForRow:5 inSection:50]];
    for (NSArray *contents in [_testObj.contentsDic allValues]) {
        XCTAssertTrue([contents count] == [_testObj contentCount], @"指定した件数のコンテンツが生成されていない");
    }
    
    [_testObj createContentsWithIndexPath:nil];
    XCTAssertTrue([_testObj contentCount] == 0, @"引数にnilを指定した場合にコンテンツ件数が0になっていない");
}

@end
