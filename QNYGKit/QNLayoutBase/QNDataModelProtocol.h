//
//  QNDataModelProtocol.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNModelProtocol.h"

@protocol QNDataModelProtocol <NSObject>
- (instancetype)initWithModel:(id<QNModelProtocol>)model;
@property(nonatomic, assign) BOOL isInvalid;
@end
