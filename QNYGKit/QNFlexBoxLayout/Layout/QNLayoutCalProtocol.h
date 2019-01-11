//
//  QNLayoutCalProtocol.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/20.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNLayoutCalProtocol <NSObject>

/**
 根据给定的参考尺寸计算实际的尺寸

 @param size    参考尺寸
 @return 实际尺寸
 */
- (CGSize)calculateSizeWithSize:(CGSize)size;

/**
 是否可以异步计算
 */
- (BOOL)allowAsyncCalculated;

@end

NS_ASSUME_NONNULL_END
