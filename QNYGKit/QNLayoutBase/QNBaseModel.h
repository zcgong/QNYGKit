//
//  QNBaseModel.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/4.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBaseModel : NSObject<QNModelProtocol>
@property (nonatomic, copy) NSString *ID;
@end

NS_ASSUME_NONNULL_END
