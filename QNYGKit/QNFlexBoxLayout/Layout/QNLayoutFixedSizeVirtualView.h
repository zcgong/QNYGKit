//
//  QNLayoutFixedSizeVirtualView.h
//  QQNews
//
//  Created by jayhuan on 2019/1/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QNLayoutVirtualView.h"
#import "QNLayoutVirtualView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 固定大小的虚拟视图，用来代替固定大小的view的布局计算
 */
@interface QNLayoutFixedSizeVirtualView : QNLayoutVirtualView

+ (instancetype)virtualViewWithFixedSize:(CGSize)fixedSize;

@end

NS_ASSUME_NONNULL_END
