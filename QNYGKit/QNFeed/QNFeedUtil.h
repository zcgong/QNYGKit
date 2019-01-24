//
//  QNFeedUtil.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2019/1/24.
//  Copyright © 2019 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QNFeedModel;
@interface QNFeedUtil : NSObject

+ (QNFeedModel *)fetchFirstFeedModel;

@end

NS_ASSUME_NONNULL_END
