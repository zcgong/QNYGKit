//
//  ViewController.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "ViewController.h"
#import "QNFlexBoxLayout.h"
#import "UIView+ZJ.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1、自适应，长度和高度都不限制，类似sizeToFit。
    UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectZero];
    labelA.numberOfLines = 0;
    labelA.text = @"1、自适应，长度和高度都不限制。（我是补充文字，我是补充文字，我是补充文字。）";
    labelA.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:labelA];
    [labelA qn_layoutWithWrapContent];
    labelA.top = 75;
    
    // 2、自适应，长度固定，高度不限制。
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    labelB.numberOfLines = 0;
    labelB.text = @"2、自适应，长度固定，高度不限制。（我是补充文字，我是补充文字，我是补充文字。）";
    labelB.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:labelB];
    [labelB qn_layoutWithFixedWidth];
    labelB.top = labelA.bottom + 10;
    
    // 3、自适应，高度固定，长度不限制。
    UILabel *labelC = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    labelC.numberOfLines = 0;
    labelC.text = @"3、自适应，高度固定，长度不限制。（我是补充文字，我是补充文字，我是补充文字。）";
    labelC.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:labelC];
    [labelC qn_layoutWithFixedHeight];
    labelC.top = labelB.bottom + 10;
    
    // 4、直接固定size。
    UILabel *labelD = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 42)];
    labelD.numberOfLines = 0;
    labelD.text = @"4、直接固定size。（我是补充文字，我是补充文字，我是补充文字。）";
    labelD.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:labelD];
    [labelD qn_layoutWithFixedSize];
    labelD.top = labelC.bottom + 10;
    
    // 5、组合view，水平、垂直布局等
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    mView.backgroundColor = [UIColor yellowColor];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.numberOfLines = 0;
    labelTitle.text = @"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。";
    labelTitle.backgroundColor = [UIColor orangeColor];
    [labelTitle qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();   // 自适应大小
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    QNLayoutDiv *imageDiv = [QNLayoutDiv linerLayoutDiv];
    UIImageView *imageViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 124, 78)];
    imageViewA.image = [UIImage imageNamed:@"moment_picA"];
    [imageViewA qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize(); // 固定大小，效果同下面imageViewB
    }];
    UIImageView *imageViewB = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageViewB.image = [UIImage imageNamed:@"moment_picB"];
    [imageViewB qn_makeLayout:^(QNLayout *layout) {
        layout.size.equalToSize(CGSizeMake(124, 78));
    }];
    
    UIImageView *imageViewC = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageViewC.image = [UIImage imageNamed:@"moment_picC"];
    [imageViewC qn_makeLayout:^(QNLayout *layout) {
        layout.size.equalToSize(CGSizeMake(124, 78));
    }];
    [imageDiv qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionRow));    // 水平布局
        layout.justifyContent.equalTo(@(QNJustifySpaceBetween));    // 分散排列，平分间距
        layout.children(@[imageViewA, imageViewB, imageViewC]); // 设置子view
    }];
    
    [mView qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionColumn)); // 垂直布局
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(15, 15, 10, 15));
        layout.children(@[labelTitle, imageDiv]);
    }];
    
    [mView addSubview:labelTitle];
    [mView addSubview:imageViewA];
    [mView addSubview:imageViewB];
    [mView addSubview:imageViewC];
    [self.view addSubview:mView];
    [mView qn_layoutWithFixedWidth];
    mView.top = labelD.bottom + 20;
}

@end
