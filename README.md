### 1、QNYGKit
基于Yoga实现的iOS动态布局框架。
***

### 2、Yoga是什么？
Yoga是一个实现了Flexbox规范的跨平台布局引擎，c语言实现，效率高。
***

### 3、FlexBox是什么？
弹性布局（flexible box）模块（目前是w3c候选的推荐）旨在提供一个更加有效的方式来布置，对齐和分布在容器之间的各项内容，即使它们的大小是未知或者动态变化的。
弹性布局的主要思想是让容器有能力来改变子项目的宽度和高度，以填满可用空间（主要是为了容纳所有类型的显示设备和屏幕尺寸）的能力。

目前在RN、ASDK（Texture）、ComponentKit、Weex等框架都支持FlexBox布局。

[FlexBox入门教程](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)  

***

### 4、QNYGKit特点
* 基于Yoga实现，遵循FlexBox协议，性能高，对项目侵入性较低
* QNLayout布局方便，支持链式操作，虚拟视图Div，异步计算size，多种方式计算size，布局缓存与失效
* 完全使用Div计算view的frame体系，无需创建真实view，把view的布局计算完全独立开来
* 基于协议实现兼容UITableView的使用，将数据、布局、view三者逻辑上独立
* 性能和Native基本一致
* 相对完善的单元测试
* 支持链式书写UI，提高开发效率
***

### 5、实现原理
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutb.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutd.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayouta.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutc.png)
***

### 6、性能测试
在相同测试环境下与Native以及基于AutoLayout实现的Masonry框架进行比较。

![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/performance.png)
***

### 7、使用举例（可将工程下载到本地测试）
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnygkit.png)
```objective-c
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
    UILabel *labelA = QN_Label.lines(0).bgColor([UIColor orangeColor]);
    labelA.txt(@"1、自适应，长度和高度都不限制。（我是补充文字，我是补充文字，我是补充文字。）");
    [self.view addSubview:labelA];
    [labelA qn_layoutWithWrapContent];
    labelA.top = 35;
    
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
    
    // 5、组合view，水平、垂直布局等
    UIView *mainView = QN_View_Rect(RECT_WH(SCREEN_WIDTH, 0)).bgColor([UIColor yellowColor]);
    UILabel *labelTitle = QN_Label.lines(0).fnt(15).bgColor([UIColor orangeColor]);
    labelTitle.txt(@"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。");
    [labelTitle qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();   // 自适应大小
        layout.marginB(10);
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
    QNLayoutDiv *imageDiv = [QNLayoutDiv linearLayout:^(QNLayout *layout) {
        layout.spaceBetween();    // 分散排列，平分间距
        layout.children(@[imageViewA, imageViewB, imageViewC]); // 设置子view
    }];
    
    [mainView qn_makeVerticalLayout:^(QNLayout *layout) {
        layout.padding(QN_INSETS(15, 10, 10, 10));
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
        layout.marginB(10);
    }];
    QNLayoutFixedSizeDiv *divA = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeDiv *divB = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeDiv *divC = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutDiv *linearDiv = [QNLayoutDiv linearLayout:^(QNLayout *layout) {
        layout.spaceBetween();    // 分散排列，平分间距
        layout.children(@[divA, divB, divC]); // 设置子view
    }];
    
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalLayout:^(QNLayout *layout) {
        layout.padding(QN_INSETS(15, 10, 10, 10));
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
    
    UIView *viewA = QN_View_Rect(RECT_WH(60, 60)).bgColor([UIColor purpleColor]);
    UIView *viewB = QN_View_Rect(RECT_WH(60, 60)).bgColor([UIColor greenColor]);
    UIView *viewC = QN_View_Rect(RECT_WH(60, 60)).bgColor([UIColor grayColor]);
    [viewA qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize();
    }];
    [viewB qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize().margin(QN_INSETS_LR(10, 10));
    }];
    [viewC qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize();
    }];
    QNLayoutDiv *tDiv = [QNLayoutDiv linearLayout:^(QNLayout *layout) {
        layout.justifyCenter().children(@[viewA, viewB, viewC]);
    }];
    [tDiv qn_layoutWithSize:CGSizeMake(80, 60)];
    [self.view addSubview:viewA];
    [self.view addSubview:viewB];
    [self.view addSubview:viewC];
    viewA.left += 100;
    viewB.left += 100;
    viewC.left += 100;
    viewA.top = feedView.bottom + 10;
    viewB.top = feedView.bottom + 10;
    viewC.top = feedView.bottom + 10;
    
    // 绝对布局
    UIView *bottomView = QN_View_Rect(RECT_WH(150, 150)).bgColor([UIColor blueColor]);
    [bottomView qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize().absoluteLayout();
        layout.margin(QN_INSETS_TL(self.view.height - 180, SCREEN_WIDTH - 180));
    }];
    [self.view qn_makeLayout:^(QNLayout *layout) {
        layout.children(@[bottomView]);
    }];
    [self.view addSubview:bottomView];
    [self.view qn_layoutWithFixedSize];
}
@end
```
