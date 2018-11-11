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
* 基于协议实现兼容UITableView的使用，将数据、布局、view三者逻辑上独立
* 性能和Native基本一致
* 相对完善的单元测试
***

### 实现原理
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutb.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutd.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayouta.png)
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnlayoutc.png)
***

### 性能测试
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/performance.png)
***

### 使用举例
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnygkit.png)
```objective-c
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
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    QNLayoutDiv *imageDiv = [QNLayoutDiv linerLayoutDiv];
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
    [imageDiv qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionRow));    // 水平布局
        layout.justifyContent.equalTo(@(QNJustifySpaceBetween));    // 分散排列，平分间距
        layout.children(@[imageViewA, imageViewB, imageViewC]); // 设置子view
    }];
    
    [mainView qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionColumn)); // 垂直布局
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
    QNLayoutStrDiv *titleDiv = [QNLayoutStrDiv divWithCalAttrStr:[mAttrString copy]];
    [titleDiv qn_makeLayout:^(QNLayout *layout) {
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    QNLayoutFixedSizeDiv *divA = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeDiv *divB = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutFixedSizeDiv *divC = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(114, 68)];
    QNLayoutDiv *linearDiv = [QNLayoutDiv linerLayoutDiv];
    [linearDiv qn_makeLayout:^(QNLayout *layout) {
        layout.justifyContent.equalTo(@(QNJustifySpaceBetween));    // 分散排列，平分间距
        layout.children(@[divA, divB, divC]); // 设置子view
    }];
    
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalLayoutDiv];
    [mainDiv qn_makeLayout:^(QNLayout *layout) {
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
}
@end
```
