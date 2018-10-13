//
//  QNBaseDataModel.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/4.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNBaseDataModel.h"

@implementation QNBaseDataModel

- (instancetype)initWithModel:(id<QNModelProtocol>)model {
    if (self = [super init]) {
        [self applyModel:model];
    }
    return self;
}

- (void)applyModel:(id<QNModelProtocol>)model {

}

@end
