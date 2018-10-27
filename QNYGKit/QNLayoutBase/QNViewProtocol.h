//
//  QNViewProtocol.h
//  FlexBoxLayout_Example
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 qiang.shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNDataModelProtocol.h"
#import "QNLayoutModelProtocol.h"
#import "QNViewModelItem.h"

@protocol QNViewProtocol <NSObject>

- (void)applyDataModel:(id<QNDataModelProtocol>)dataModel;
- (void)applyLayoutModel:(id<QNLayoutModelProtocol>)layoutModel;
- (void)applyViewModelItem:(QNViewModelItem *)viewModelItem;

@end
