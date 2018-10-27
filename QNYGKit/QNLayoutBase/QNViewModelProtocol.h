//
//  QNViewModelProtocol.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/4.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNViewModelProtocol <NSObject>

+ (QNViewModelItem *)getViewModelItemWithModel:(id<QNModelProtocol>)model;

@end

NS_ASSUME_NONNULL_END
