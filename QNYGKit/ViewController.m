//
//  ViewController.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "ViewController.h"
#import "QNFeedView.h"

@interface ViewController ()
@property(nonatomic, strong) UILabel *testlabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
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
//    [feedView applyModel:feedModel];
    QNViewModelItem *viewModelItem = [QNFeedViewModel getViewModelItemWithModel:feedModel];
    [feedView applyViewModelItem:viewModelItem];
    feedView.frame = CGRectMake(0, 64, feedView.frame.size.width, feedView.frame.size.height);
    feedView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:feedView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        QNFeedModel *feedModel = [feeds objectAtIndex:1];
        QNViewModelItem *viewModelItem = [QNFeedViewModel getViewModelItemWithModel:feedModel];
        [feedView applyViewModelItem:viewModelItem];
        feedView.frame = CGRectMake(0, 64, feedView.frame.size.width, feedView.frame.size.height);
        feedView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:feedView];
    });
    */
    
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 0, 10));
    }];
    label.text = @"hello world";
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor orangeColor];
//    [label qn_applyLayoutWithFixedWidth];
//    label.frame = CGRectMake(10, 164, label.frame.size.width, label.frame.size.height);
//    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    imageView.backgroundColor = [UIColor greenColor];
//    [imageView qn_markAllowLayout];
//    [imageView qn_makeLayout:^(QNLayout *layout) {
//        layout.width.height.equalTo(@(100));
//    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 414, 0)];
    [view qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionColumn));
        layout.children(@[label, imageView]);
    }];
    [view addSubview:imageView];
    [view addSubview:label];
    view.backgroundColor = [UIColor purpleColor];
    [view qn_applyLayoutWithFixedWidth];
    QNLayoutCache *cache = [view.qn_layout layoutCache];
    view.frame = CGRectMake(0, 164, view.frame.size.width, view.frame.size.height);
    [self.view addSubview:view];
     */
    
    self.testlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    self.testlabel.backgroundColor = [UIColor orangeColor];
    self.testlabel.text = @"Hello world, hello world, hello world";
//    [self.testlabel sizeToFit];
//    [self.testlabel qn_markAllowLayout];
//    [self.testlabel qn_makeLayout:^(QNLayout *layout) {
//        layout.wrapContent();
//    }];
    [self.testlabel qn_applyLayouWithSize:CGSizeMake(300, 100)];
    [self.view addSubview:self.testlabel];
    self.testlabel.frame = CGRectMake(0, 120, self.testlabel.frame.size.width, self.testlabel.frame.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
