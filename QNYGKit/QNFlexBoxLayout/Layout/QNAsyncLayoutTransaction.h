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

+ (void)addCalculateBlock:(dispatch_block_t)calculateBlock
                       complete:(nullable dispatch_block_t)complete;

+ (void)addDisplayBlock:(dispatch_block_t)displayBlock
                     complete:(dispatch_block_t)complete;

@end

NS_ASSUME_NONNULL_END
