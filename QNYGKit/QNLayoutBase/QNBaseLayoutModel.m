//
//  QNBaseLayoutModel.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/27.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNBaseLayoutModel.h"

@implementation QNBaseLayoutModel

- (instancetype)initWithDataModel:(id<QNDataModelProtocol>)dataModel {
    if (self = [super init]) {
        NSAssert(dataModel, @"invalid");
        [self applyDataModel:dataModel];
    }
    return self;
}

- (void)applyDataModel:(id<QNDataModelProtocol>)dataModel {
    
}

@end
