//
//  QNBaseView.m
//  FlexBoxLayout_Example
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 qiang.shen. All rights reserved.
//

#import "QNBaseView.h"

@implementation QNBaseView

+ (instancetype)defaultView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
}

- (void)applyDataModel:(id<QNDataModelProtocol>)dataModel {
    
}

- (void)applyViewModelItem:(QNViewModelItem *)viewModelItem {
    [self applyDataModel:viewModelItem.dataModel];
    [self.qn_layout applyLayoutCache:viewModelItem.layoutCache];
}

@end
