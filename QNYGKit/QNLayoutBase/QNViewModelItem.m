//
//  QNViewModelItem.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNViewModelItem.h"

@implementation QNViewModelItem

- (void)markDataModelDirty {
    self.dataModel.isInvalid = YES;
}

- (void)markLayoutModelDirty {
    self.layoutModel.isInvalid = YES;
}

@end
