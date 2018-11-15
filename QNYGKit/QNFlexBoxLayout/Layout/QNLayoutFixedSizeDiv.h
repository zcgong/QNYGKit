//
//  QNLayoutFixedSizeDiv.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/20.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNLayoutDiv.h"

NS_ASSUME_NONNULL_BEGIN

/**
 固定尺寸的div，可以代替固定大小的view的布局
 */
@interface QNLayoutFixedSizeDiv : QNLayoutDiv
+ (instancetype)divWithFixedSize:(CGSize)fixedSize;
@end

NS_ASSUME_NONNULL_END
