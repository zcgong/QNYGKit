//
//  QNFeedViewLayoutModel.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/27.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBaseLayoutModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNFeedViewLayoutModel : QNBaseLayoutModel
@property(nonatomic, assign, readonly) CGRect titleFrame;
@property(nonatomic, assign, readonly) CGRect contentStrFrame;
@property(nonatomic, assign, readonly) CGRect contentImageFrame;
@property(nonatomic, assign, readonly) CGRect userStrFrame;
@property(nonatomic, assign, readonly) CGRect timeStrFrame;
@end

NS_ASSUME_NONNULL_END
