//
//  QNBaseDataModel.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/4.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNDataModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBaseDataModel : NSObject<QNDataModelProtocol>
- (void)applyModel:(id<QNModelProtocol>)model;
@end

NS_ASSUME_NONNULL_END
