//
//  QNLayoutModelProtocol.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/27.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QNDataModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNLayoutModelProtocol <NSObject>
@property(nonatomic, assign) CGRect frame;
- (instancetype)initWithDataModel:(id<QNDataModelProtocol>)dataModel;
@end

NS_ASSUME_NONNULL_END
