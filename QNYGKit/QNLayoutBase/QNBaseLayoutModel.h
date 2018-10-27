//
//  QNBaseLayoutModel.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/27.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNLayoutModelProtocol.h"
#import "QNDataModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBaseLayoutModel : NSObject<QNLayoutModelProtocol>
@property(nonatomic, assign) CGRect frame;
- (void)applyDataModel:(id<QNDataModelProtocol>)dataModel;
@end

NS_ASSUME_NONNULL_END
