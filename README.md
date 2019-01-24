### 1、QNYGKit
基于Yoga实现的iOS动态布局框架。
***

### 2、Yoga是什么？
Yoga是一个实现了Flexbox规范的跨平台布局引擎，c语言实现，效率高。
***

### 3、FlexBox是什么？
Flexbox布局，是一种灵活的CSS布局方式，可简单、方便、快捷的实现复杂页面布局，目前Texture、ComponentKit、RN、Weex等开源框架都支持Flexbox布局。

[FlexBox入门教程](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)  

***

### 4、QNYGKit特点
* 基于Yoga实现，遵循FlexBox协议，性能高，侵入性低
* 支持链式书写UI和布局
* 提供多种方式计算size，支持异步计算
* 布局缓存与失效，支持动态调整布局
* 完全使用虚拟视图VirtualView计算布局体系，无需创建真实view，把view的布局计算完全独立开来
* 基于协议实现兼容UITableView的使用，将数据、布局、view逻辑解耦
* 性能与Native基本一致
***

### 5、实现原理
##### 核心架构
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/core_arthitecture.png)

##### 整体架构
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/all_architecture.png)

##### UIView与VirtualView完全等价
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/view.png)
***

### 6、性能测试
#####在相同测试环境下与Native以及YogaKit进行比较。

![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/benchmark.png)
***

### 7、使用举例（可将工程下载到本地测试）
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnygkit.png)
```objective-c
// 1、自适应，长度和高度都不限制，类似sizeToFit。
    UILabel *labelA = QN_Label.lines(0).bgColor([UIColor orangeColor]);
    labelA.txt(@"1、自适应，长度和高度都不限制。（我是补充文字，我是补充文字，我是补充文字。）");
    [labelA qn_layoutWithWrapContent];
    labelA.top = 50;
    
    // 2、自适应，长度固定，高度不限制。
    UILabel *labelB = QN_Label_Rect(RECT_WH(SCREEN_WIDTH, 0)).lines(0).bgColor([UIColor orangeColor]);
    labelB.txt(@"2、自适应，长度固定，高度不限制。（我是补充文字，我是补充文字，我是补充文字。）");
    [labelB qn_layoutWithFixedWidth];
    labelB.top = labelA.bottom + 10;
    
    // 3、自适应，高度固定，长度不限制。
    UILabel *labelC = QN_Label_Rect(RECT_WH(0, 50)).lines(0).bgColor([UIColor orangeColor]);
    labelC.txt(@"3、自适应，高度固定，长度不限制。（我是补充文字，我是补充文字，我是补充文字。）");
    [labelC qn_layoutWithFixedHeight];
    labelC.top = labelB.bottom + 10;
    
    // 4、直接固定size。
    UILabel *labelD = QN_Label_Rect(RECT_WH(300, 42)).lines(0).bgColor([UIColor orangeColor]);
    labelD.txt(@"4、直接固定size。（我是补充文字，我是补充文字，我是补充文字。）");
    [labelD qn_layoutWithFixedSize];
    labelD.top = labelC.bottom + 10;
    
    [self.view qn_addSubviews:@[labelA, labelB, labelC, labelD]];
    
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
    [mainView qn_addSubviews:@[labelTitle, imageViewA, imageViewB, imageViewC]];
    
    [self.view addSubview:mainView];
    [mainView qn_layoutWithFixedWidth];
    mainView.top = labelD.bottom + 10;
    
    // 6、完全使用VirtualView计算frame
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
    [mainVV qn_layoutWithSize:CGSizeMake(SCREEN_WIDTH, QNUndefinedValue)];
    
    NSAssert(CGSizeEqualToSize(mainVV.frame.size, mainView.frame.size), @"main frame not equal");
    NSAssert(CGRectEqualToRect(labelTitle.frame, titleVV.frame), @"title frame not equal");
    NSAssert(CGRectEqualToRect(divA.frame, imageViewA.frame), @"A frame not equal");
    NSAssert(CGRectEqualToRect(divB.frame, imageViewB.frame), @"B frame not equal");
    NSAssert(CGRectEqualToRect(divC.frame, imageViewC.frame), @"C frame not equal");
    
    QNFeedModel *feedModel = [QNFeedUtil fetchFirstFeedModel];
    QNFeedView *feedView = [QNFeedView defaultFeedView].bgColor([UIColor orangeColor]);
    QNViewModelItem *viewModelItem = [QNFeedViewModel getViewModelItemWithModel:feedModel];
    [feedView applyViewModelItem:viewModelItem];
    feedView.top = mainView.bottom + 10;
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
```
