//
//  QNAsyncLayoutTransaction.h
//  QNYGKit
//
//  Created by jayhuan on 2018/10/15.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNAsyncLayoutTransaction : NSObject

/**
 添加异步任务
 
 @param calculateBlock 子线程计算布局
 @param complete 主线程渲染
 */
+ (void)addCalculateBlock:(dispatch_block_t)calculateBlock
                 complete:(dispatch_block_t)complete;


@end

NS_ASSUME_NONNULL_END
