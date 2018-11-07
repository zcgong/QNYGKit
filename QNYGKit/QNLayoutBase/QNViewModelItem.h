//
//  QNViewModelItem.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNModelProtocol.h"
#import "QNDataModelProtocol.h"
#import "QNLayoutModelProtocol.h"

@interface QNViewModelItem : NSObject
@property(nonatomic, strong) id<QNModelProtocol> model;
@property(nonatomic, strong) id<QNDataModelProtocol> dataModel;
@property(nonatomic, strong) id<QNLayoutModelProtocol> layoutModel;
- (void)markDataModelDirty;
- (void)markLayoutModelDirty;
@end
