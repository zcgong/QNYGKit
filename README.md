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
* 基于Yoga实现，遵循FlexBox协议，性能高，对项目侵入性较低；
* QNLayout布局方便，支持链式操作，虚拟视图Div，异步计算size，多种方式计算size，布局缓存与失效
* 基于协议实现兼容UITableView的使用
***

### 使用举例
```
UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100)];
    [self.view addSubview:bgView];
    // 1、自适应，长度和高度都不限制，类似sizeToFit。
    UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectZero];
    labelA.numberOfLines = 0;
    labelA.text = @"1、自适应，长度和高度都不限制。（我是补充文字，我是补充文字，我是补充文字。）";
    labelA.backgroundColor = [UIColor orangeColor];
    [bgView addSubview:labelA];
    [labelA qn_layoutWithWrapContent];
    
    // 2、自适应，长度固定，高度不限制。
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    labelB.numberOfLines = 0;
    labelB.text = @"2、自适应，长度固定，高度不限制。（我是补充文字，我是补充文字，我是补充文字。）";
    labelB.backgroundColor = [UIColor orangeColor];
    [bgView addSubview:labelB];
    [labelB qn_layoutWithFixedWidth];
    labelB.top = labelA.bottom + 10;
    
    // 3、自适应，高度固定，长度不限制。
    UILabel *labelC = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    labelC.numberOfLines = 0;
    labelC.text = @"3、自适应，高度固定，长度不限制。（我是补充文字，我是补充文字，我是补充文字。）";
    labelC.backgroundColor = [UIColor orangeColor];
    [bgView addSubview:labelC];
    [labelC qn_layoutWithFixedHeight];
    labelC.top = labelB.bottom + 10;
    
    // 4、直接固定size。
    UILabel *labelD = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 42)];
    labelD.numberOfLines = 0;
    labelD.text = @"4、直接固定size。（我是补充文字，我是补充文字，我是补充文字。）";
    labelD.backgroundColor = [UIColor orangeColor];
    [bgView addSubview:labelD];
    [labelD qn_layoutWithFixedSize];
    labelD.top = labelC.bottom + 10;
    
    // 5、组合view，水平、垂直布局等
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    mView.backgroundColor = [UIColor yellowColor];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.numberOfLines = 0;
    labelTitle.text = @"5、组合布局：我是标题，我是标题，我是标题。不限行数，不限行数，不限行数。";
    labelTitle.backgroundColor = [UIColor orangeColor];
    [labelTitle qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    QNLayoutDiv *imageDiv = [QNLayoutDiv  linerLayoutDiv];
    UIImageView *imageViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 124, 78)];
    imageViewA.backgroundColor = [UIColor blueColor];
    imageViewA.image = [UIImage imageNamed:@"moment_picA"];
    [imageViewA qn_makeLayout:^(QNLayout *layout) {
        layout.wrapSize(); // 效果同下面imageViewB
    }];
    UIImageView *imageViewB = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageViewB.backgroundColor = [UIColor greenColor];
    imageViewB.image = [UIImage imageNamed:@"moment_picB"];
    [imageViewB qn_makeLayout:^(QNLayout *layout) {
        layout.size.equalToSize(CGSizeMake(124, 78));
    }];
    
    UIImageView *imageViewC = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageViewC.backgroundColor = [UIColor greenColor];
    imageViewC.image = [UIImage imageNamed:@"moment_picC"];
    [imageViewC qn_makeLayout:^(QNLayout *layout) {
        layout.size.equalToSize(CGSizeMake(124, 78));
    }];
    [imageDiv qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionRow)); layout.justifyContent.equalTo(@(QNJustifySpaceBetween));
        layout.children(@[imageViewA, imageViewB, imageViewC]);
    }];
    
    [mView qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionColumn));
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(15, 15, 10, 15));
        layout.children(@[labelTitle, imageDiv]);
    }];
    
    [mView addSubview:labelTitle];
    [mView addSubview:imageViewA];
    [mView addSubview:imageViewB];
    [mView addSubview:imageViewC];
    [bgView addSubview:mView];
    [mView qn_layoutWithFixedWidth];
    mView.top = labelD.bottom + 20;
```
![Image text](https://github.com/nannanIT/QNYGKit/blob/master/QNYGKit/Images/qnygkit.png)
