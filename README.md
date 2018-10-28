### QNYGKit
基于Yoga实现的iOS动态布局框架。
***

### Yoga是什么？
Yoga是一个实现了Flexbox规范的跨平台布局引擎，c语言实现，效率高。
***

### FlexBox是什么？
弹性布局（flexible box）模块（目前是w3c候选的推荐）旨在提供一个更加有效的方式来布置，对齐和分布在容器之间的各项内容，即使它们的大小是未知或者动态变化的。
弹性布局的主要思想是让容器有能力来改变子项目的宽度和高度，以填满可用空间（主要是为了容纳所有类型的显示设备和屏幕尺寸）的能力。

[FlexBox入门教程](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)  

***

### 特点
* 基于Yoga实现，遵循FlexBox协议，性能高，对项目侵入性较低
* QNLayout布局方便，支持链式操作，虚拟视图Div，异步计算size，多种方式计算size，布局缓存与失效
* 完全使用Div计算view的frame体系，无需创建真实view，把view的布局计算完全独立开来
* 基于协议实现兼容UITableView的使用
* 相对完善的单元测试
***

### 实现原理
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayouta.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutb.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutc.png)
***

### 使用举例
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
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    mainView.backgroundColor = [UIColor yellowColor];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.numberOfLines = 0;
    labelTitle.font = [UIFont systemFontOfSize:15];
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
    
    [mainView qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionColumn)); // 垂直布局
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(15, 15, 10, 15));
        layout.children(@[labelTitle, imageDiv]);
    }];
    
    [mainView addSubview:labelTitle];
    [mainView addSubview:imageViewA];
    [mainView addSubview:imageViewB];
    [mainView addSubview:imageViewC];
    [self.view addSubview:mainView];
    [mainView qn_layoutWithFixedWidth];
    mainView.top = labelD.bottom + 20;
    
    // 6、完全使用Div计算view的frame
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:@"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。" attributes:attrDict];
    QNLayoutStrDiv *titleDiv = [QNLayoutStrDiv layoutStrDivWithCalAttrStr:[mAttrString copy]];
    [titleDiv qn_makeLayout:^(QNLayout *layout) {
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    QNLayoutFixedSizeDiv *divA = [QNLayoutFixedSizeDiv layoutFixedSizeDivWithFixedSize:CGSizeMake(124, 78)];
    QNLayoutFixedSizeDiv *divB = [QNLayoutFixedSizeDiv layoutFixedSizeDivWithFixedSize:CGSizeMake(124, 78)];
    QNLayoutFixedSizeDiv *divC = [QNLayoutFixedSizeDiv layoutFixedSizeDivWithFixedSize:CGSizeMake(124, 78)];
    QNLayoutDiv *linearDiv = [QNLayoutDiv linerLayoutDiv];
    [linearDiv qn_makeLayout:^(QNLayout *layout) {
        layout.justifyContent.equalTo(@(QNJustifySpaceBetween));    // 分散排列，平分间距
        layout.children(@[divA, divB, divC]); // 设置子view
    }];
    
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalLayoutDiv];
    [mainDiv qn_makeLayout:^(QNLayout *layout) {
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(15, 15, 10, 15));
        layout.children(@[titleDiv, linearDiv]);
    }];
    [mainDiv qn_layoutWithSize:CGSizeMake(SCREEN_WIDTH, QNUndefinedValue)];
    NSAssert(CGSizeEqualToSize(mainDiv.frame.size, mainView.frame.size), @"main frame not equal");
    NSAssert(CGRectEqualToRect(labelTitle.frame, titleDiv.frame), @"title frame not equal");
    NSAssert(CGRectEqualToRect(divA.frame, imageViewA.frame), @"A frame not equal");
    NSAssert(CGRectEqualToRect(divB.frame, imageViewB.frame), @"B frame not equal");
    NSAssert(CGRectEqualToRect(divC.frame, imageViewC.frame), @"C frame not equal");
}
@end
```
