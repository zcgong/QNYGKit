//
//  QNBaseView.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNBaseView.h"

@implementation QNBaseView

- (void)applyDataModel:(id<QNDataModelProtocol>)dataModel {
    
}

- (void)applyLayoutModel:(id<QNLayoutModelProtocol>)layoutModel {
    self.frame = layoutModel.frame;
}

- (void)applyViewModelItem:(QNViewModelItem *)viewModelItem {
    [self applyDataModel:viewModelItem.dataModel];
    [self applyLayoutModel:viewModelItem.layoutModel];
}

@end
