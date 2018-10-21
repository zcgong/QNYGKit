//
//  QNViewProtocol.h
//  FlexBoxLayout_Example
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 qiang.shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNModelProtocol.h"
#import "QNDataModelProtocol.h"
#import "QNViewModelItem.h"

@protocol QNViewProtocol <NSObject>

+ (instancetype)defaultView;
- (void)applyModel:(id<QNModelProtocol>)model;
- (void)applyDataModel:(id<QNDataModelProtocol>)dataModel;
- (void)applyViewModelItem:(QNViewModelItem *)viewModelItem;

@end
