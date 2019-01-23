//
//  ViewController.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "ViewController.h"
#import "QNYGKit.h"
#import "UIView+ZJ.h"
#import "QNFeedView.h"
#import "QNFeedModel.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1、自适应，长度和高度都不限制，类似sizeToFit。
    UILabel *labelA = QN_Label.lines(0).bgColor([UIColor orangeColor]);
    labelA.txt(@"1、自适应，长度和高度都不限制。（我是补充文字，我是补充文字，我是补充文字。）");
    [self.view addSubview:labelA];
    [labelA qn_layoutWithWrapContent];
    labelA.top = 50;
    
    // 2、自适应，长度固定，高度不限制。
    UILabel *labelB = QN_Label_Rect(RECT_WH(SCREEN_WIDTH, 0)).lines(0).bgColor([UIColor orangeColor]);
    labelB.txt(@"2、自适应，长度固定，高度不限制。（我是补充文字，我是补充文字，我是补充文字。）");
    [self.view addSubview:labelB];
    [labelB qn_layoutWithFixedWidth];
    labelB.top = labelA.bottom + 10;
    
    // 3、自适应，高度固定，长度不限制。
    UILabel *labelC = QN_Label_Rect(RECT_WH(0, 50)).lines(0).bgColor([UIColor orangeColor]);
    labelC.txt(@"3、自适应，高度固定，长度不限制。（我是补充文字，我是补充文字，我是补充文字。）");
    [self.view addSubview:labelC];
    [labelC qn_layoutWithFixedHeight];
    labelC.top = labelB.bottom + 10;
    
    // 4、直接固定size。
    UILabel *labelD = QN_Label_Rect(RECT_WH(300, 42)).lines(0).bgColor([UIColor orangeColor]);
    labelD.txt(@"4、直接固定size。（我是补充文字，我是补充文字，我是补充文字。）");
    [self.view addSubview:labelD];
    [labelD qn_layoutWithFixedSize];
    labelD.top = labelC.bottom + 10;
    
    UILabel *labelE = QN_Label_Rect(RECT_WH(300, 42)).lines(0).bgColor([UIColor orangeColor]);
    labelE.txt(@"4321、直接固定size。（我是补充文字，我是补充文字，我是补充文字。）");
    [self.view addSubview:labelE];
    [labelE qn_layoutWithWrapContent];
    labelE.top = labelD.bottom + 10;
    
    // 5、组合view，水平、垂直布局等
    UIView *mainView = QN_View_Rect(RECT_WH(SCREEN_WIDTH, 0)).bgColor([UIColor yellowColor]);
    UILabel *labelTitle = QN_Label.lines(0).fnt(15).bgColor([UIColor orangeColor]);
    labelTitle.txt(@"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。");
    [labelTitle qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent().marginB(10);
    }];
    
    UIImageView *imageViewA = QN_ImageView_Rect(RECT_WH(114, 68)).imgName(@"moment_picA");
    [imageViewA qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize(); // 固定大小，效果同下面imageViewB
    }];
    UIImageView *imageViewB = QN_ImageView.imgName(@"moment_picB");
    [imageViewB qn_makeLayout:^(QNLayout *layout) {
        layout.size(CGSizeMake(114, 68));
    }];
    
    UIImageView *imageViewC = QN_ImageView.imgName(@"moment_picC");
    [imageViewC qn_makeLayout:^(QNLayout *layout) {
        layout.size(CGSizeMake(114, 68));
    }];
    QNLayoutVirtualView *imageVV = [QNLayoutVirtualView linearLayout:^(QNLayout *layout) {
        layout.spaceBetween().children(@[imageViewA, imageViewB, imageViewC]);
    }];
    
    [mainView qn_makeVerticalLayout:^(QNLayout *layout) {
        layout.padding(QN_INSETS(15, 10, 10, 10)).children(@[labelTitle, imageVV]);
    }];
    
    [mainView addSubview:labelTitle];
    [mainView addSubview:imageViewA];
    [mainView addSubview:imageViewB];
    [mainView addSubview:imageViewC];
    [self.view addSubview:mainView];
    [mainView qn_layoutWithFixedWidth];
    mainView.top = labelE.bottom + 10;
    
    // 6、完全使用Div计算view的frame
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:@"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。" attributes:attrDict];
    QNLayoutTextVirtualView *titleVV = [QNLayoutTextVirtualView virtualViewWithAttributedString:[mAttrString copy]];
    [titleVV qn_makeLayout:^(QNLayout *layout) {
        layout.marginB(10);
    }];
    QNLayoutFixedSizeVirtualView *divA = [QNLayoutFixedSizeVirtualView virtualViewWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeVirtualView *divB = [QNLayoutFixedSizeVirtualView virtualViewWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeVirtualView *divC = [QNLayoutFixedSizeVirtualView virtualViewWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutVirtualView *linearVV = [QNLayoutVirtualView linearLayout:^(QNLayout *layout) {
        layout.spaceBetween().children(@[divA, divB, divC]); // 设置子view
    }];
    
    QNLayoutVirtualView *mainVV = [QNLayoutVirtualView verticalLayout:^(QNLayout *layout) {
        layout.padding(QN_INSETS(15, 10, 10, 10)).children(@[titleVV, linearVV]);
    }];

    [mainVV qn_asyncLayoutWithSize:CGSizeMake(SCREEN_WIDTH, QNUndefinedValue) complete:^(CGRect frame) {
        NSAssert(CGSizeEqualToSize(mainVV.frame.size, mainView.frame.size), @"main frame not equal");
        NSAssert(CGRectEqualToRect(labelTitle.frame, titleVV.frame), @"title frame not equal");
        NSAssert(CGRectEqualToRect(divA.frame, imageViewA.frame), @"A frame not equal");
        NSAssert(CGRectEqualToRect(divB.frame, imageViewB.frame), @"B frame not equal");
        NSAssert(CGRectEqualToRect(divC.frame, imageViewC.frame), @"C frame not equal");
    }];
    
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
    
    // 绝对布局
    UIView *bottomView = QN_View_Rect(RECT_WH(100, 100)).bgColor([UIColor orangeColor]);
    [bottomView qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize().marginB(30).alignSelfEnd().marginL(20);
    }];
    [self.view qn_makeLinearLayout:^(QNLayout *layout) {
        layout.children(@[bottomView]);
    }];
    [self.view addSubview:bottomView];
    [self.view qn_layoutWithFixedSize];
}

@end
