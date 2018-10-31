//
//  QNViewModelItem.m
//  FlexBoxLayout_Example
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 qiang.shen. All rights reserved.
//

#import "QNViewModelItem.h"

@implementation QNViewModelItem

- (void)markDataModelDirty {
    self.dataModel.isInvalid =  YES;
}

- (void)markLayoutModelDirty {
    self.layoutModel.isInvalid =  YES;
}

@end
