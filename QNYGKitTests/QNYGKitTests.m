//
//  QNYGKitTests.m
//  QNYGKitTests
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QNFlexBoxLayout.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@interface QNYGKitTests : XCTestCase


@end

@implementation QNYGKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStrDiv {
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:@"我是字符串，我是字符串，我是字符串，我是字符串，我是字符串" attributes:attrDict];
    NSAttributedString *attrString = [mAttrString copy];
    QNLayoutStrDiv *strDiv = [QNLayoutStrDiv divWithAttributedString:attrString];
    [strDiv qn_layoutWithWrapContent];
    CGRect strFrame = [attrString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    strFrame = CGRectMake(0, 0, ceil(strFrame.size.width), ceil(strFrame.size.height));
    XCTAssert(CGRectEqualToRect(strDiv.frame, strFrame), @"invalid");
}

- (void)testVerticalLayout {
    QNLayoutFixedSizeDiv *fixedSizeDivA = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 50)];
    [fixedSizeDivA qn_makeLayout:^(QNLayout *layout) {
        layout.margin(UIEdgeInsetsMake(5, 10, 12, 0));
    }];
    
    QNLayoutFixedSizeDiv *fixedSizeDivB = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 50)];
    [fixedSizeDivB qn_makeLayout:^(QNLayout *layout) {
        layout.margin(UIEdgeInsetsMake(12, 5, 8, 0));
    }];
    
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalLayout:^(QNLayout *layout) {
        layout.padding(UIEdgeInsetsMake(3, 4, 5, 6));
        layout.children(@[fixedSizeDivA, fixedSizeDivB]);
    }];
    [mainDiv qn_layoutWithSize:CGSizeMake(SCREEN_WIDTH, QNUndefinedValue)];
    XCTAssert(CGRectEqualToRect(fixedSizeDivA.frame, CGRectMake(14, 8, 100, 50)), @"fixedSizeDivA frame invalid");
    XCTAssert(CGRectEqualToRect(fixedSizeDivB.frame, CGRectMake(9, 82, 100, 50)), @"fixedSizeDivA frame invalid");
    XCTAssert(CGRectEqualToRect(mainDiv.frame, CGRectMake(0, 0, SCREEN_WIDTH, 145)), @"div frame invalid");
}

- (void)testLinearLayout {
    QNLayoutFixedSizeDiv *fixedSizeDivA = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 50)];
    [fixedSizeDivA qn_makeLayout:^(QNLayout *layout) {
        layout.margin(UIEdgeInsetsMake(5, 10, 12, 10));
    }];
    
    QNLayoutFixedSizeDiv *fixedSizeDivB = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 60)];
    [fixedSizeDivB qn_makeLayout:^(QNLayout *layout) {
        layout.margin(UIEdgeInsetsMake(12, 5, 8, 0));
    }];
    
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalLayout:^(QNLayout *layout) {
        layout.padding(UIEdgeInsetsMake(3, 4, 5, 6));
        layout.children(@[fixedSizeDivA, fixedSizeDivB]);
    }];
    [mainDiv qn_layoutWithSize:CGSizeMake(SCREEN_WIDTH, QNUndefinedValue)];
    XCTAssert(CGRectEqualToRect(fixedSizeDivA.frame, CGRectMake(14, 8, 100, 50)), @"fixedSizeDivA frame invalid");
    XCTAssert(CGRectEqualToRect(fixedSizeDivB.frame, CGRectMake(129, 15, 100, 60)), @"fixedSizeDivA frame invalid");
    XCTAssert(CGRectEqualToRect(mainDiv.frame, CGRectMake(0, 0, SCREEN_WIDTH, 88)), @"div frame invalid");
}

- (void)testJustify {
    QNLayoutFixedSizeDiv *fixedSizeDivA = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 50)];
    
    QNLayoutFixedSizeDiv *fixedSizeDivB = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 60)];
    QNLayoutDiv *mainDiv = [QNLayoutDiv linearLayout:^(QNLayout *layout) {
        layout.justifyContent(QNJustifySpaceBetween);
        layout.padding(UIEdgeInsetsMake(10, 12, 15, 18));
        layout.children(@[fixedSizeDivA, fixedSizeDivB]);
    }];
    [mainDiv qn_layoutWithSize:CGSizeMake(SCREEN_WIDTH, QNUndefinedValue)];
    XCTAssert(CGRectEqualToRect(fixedSizeDivA.frame, CGRectMake(12, 10, 100, 50)), @"fixedSizeDivA frame invalid");
    XCTAssert(CGRectEqualToRect(fixedSizeDivB.frame, CGRectMake(SCREEN_WIDTH - 118, 10, 100, 60)), @"fixedSizeDivA frame invalid");
    XCTAssert(CGRectEqualToRect(mainDiv.frame, CGRectMake(0, 0, SCREEN_WIDTH, 85)), @"div frame invalid");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
