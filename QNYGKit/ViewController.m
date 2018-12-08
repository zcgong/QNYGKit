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
#import "QNFeedView.h"
#import "QNFeedModel.h"

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
    labelA.top = 35;
    
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
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    mainView.backgroundColor = [UIColor yellowColor];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.numberOfLines = 0;
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.text = @"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。";
    labelTitle.backgroundColor = [UIColor orangeColor];
    [labelTitle qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();   // 自适应大小
        layout.marginB.equalTo(@(10));
    }];
    
    UIImageView *imageViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 114, 68)];
    imageViewA.image = [UIImage imageNamed:@"moment_picA"];
    [imageViewA qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize(); // 固定大小，效果同下面imageViewB
    }];
    UIImageView *imageViewB = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageViewB.image = [UIImage imageNamed:@"moment_picB"];
    [imageViewB qn_makeLayout:^(QNLayout *layout) {
        layout.size.equalToSize(CGSizeMake(114, 68));
    }];
    
    UIImageView *imageViewC = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageViewC.image = [UIImage imageNamed:@"moment_picC"];
    [imageViewC qn_makeLayout:^(QNLayout *layout) {
        layout.size.equalToSize(CGSizeMake(114, 68));
    }];
    QNLayoutDiv *imageDiv = [QNLayoutDiv linearDivWithLayout:^(QNLayout *layout) {
        layout.spaceBetween();    // 分散排列，平分间距
        layout.children(@[imageViewA, imageViewB, imageViewC]); // 设置子view
    }];
    
    [mainView qn_makeVerticalLayout:^(QNLayout *layout) {
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(15, 10, 10, 10));
        layout.children(@[labelTitle, imageDiv]);
    }];
    
    [mainView addSubview:labelTitle];
    [mainView addSubview:imageViewA];
    [mainView addSubview:imageViewB];
    [mainView addSubview:imageViewC];
    [self.view addSubview:mainView];
    [mainView qn_layoutWithFixedWidth];
    mainView.top = labelD.bottom + 10;
    
    // 6、完全使用Div计算view的frame
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:@"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。" attributes:attrDict];
    QNLayoutStrDiv *titleDiv = [QNLayoutStrDiv divWithAttributedString:[mAttrString copy]];
    [titleDiv qn_makeLayout:^(QNLayout *layout) {
        layout.marginB.equalTo(@(10));
    }];
    QNLayoutFixedSizeDiv *divA = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeDiv *divB = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeDiv *divC = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutDiv *linearDiv = [QNLayoutDiv linearDivWithLayout:^(QNLayout *layout) {
        layout.spaceBetween();    // 分散排列，平分间距
        layout.children(@[divA, divB, divC]); // 设置子view
    }];
    
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalDivWithLayout:^(QNLayout *layout) {
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(15, 10, 10, 10));
        layout.children(@[titleDiv, linearDiv]);
    }];

    [mainDiv qn_layoutWithSize:CGSizeMake(SCREEN_WIDTH, QNUndefinedValue)];
    NSAssert(CGSizeEqualToSize(mainDiv.frame.size, mainView.frame.size), @"main frame not equal");
    NSAssert(CGRectEqualToRect(labelTitle.frame, titleDiv.frame), @"title frame not equal");
    NSAssert(CGRectEqualToRect(divA.frame, imageViewA.frame), @"A frame not equal");
    NSAssert(CGRectEqualToRect(divB.frame, imageViewB.frame), @"B frame not equal");
    NSAssert(CGRectEqualToRect(divC.frame, imageViewC.frame), @"C frame not equal");
    
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *feedDicts = rootDict[@"feed"];
    
    NSMutableArray *feeds = @[].mutableCopy;
    
    [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [feeds addObject:[[QNFeedModel alloc] initWithDictionary:obj]];
    }];
    
    QNFeedModel *feedModel = [feeds objectAtIndex:0];
    QNFeedView *feedView = [QNFeedView defaultFeedView];
    QNViewModelItem *viewModelItem = [QNFeedViewModel getViewModelItemWithModel:feedModel];
    [feedView applyViewModelItem:viewModelItem];
    feedView.top = mainView.bottom + 10;
    feedView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:feedView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 可以模拟文字颜色变化的等情况，dataModel需要变化，layoutModel不需要变化
        [viewModelItem markDataModelDirty];
        [QNFeedViewModel updateVideoModelItem:viewModelItem];
        [feedView applyViewModelItem:viewModelItem];
        feedView.top = mainView.bottom + 10;
    });
    
    UIView *viewA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIView *viewC = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [viewA qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize();
    }];
    [viewB qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize();
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    [viewC qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize();
    }];
    QNLayoutDiv *tDiv = [QNLayoutDiv linearDivWithLayout:^(QNLayout *layout) {
        layout.children(@[viewA, viewB, viewC]);
        layout.justifyCenter();
    }];
    [tDiv qn_layoutWithSize:CGSizeMake(80, 60)];
    [self.view addSubview:viewA];
    [self.view addSubview:viewB];
    [self.view addSubview:viewC];
    viewA.backgroundColor = [UIColor purpleColor];
    viewB.backgroundColor = [UIColor greenColor];
    viewC.backgroundColor = [UIColor grayColor];
    viewA.left += 100;
    viewB.left += 100;
    viewC.left += 100;
    viewA.top = feedView.bottom + 10;
    viewB.top = feedView.bottom + 10;
    viewC.top = feedView.bottom + 10;
}

@end
