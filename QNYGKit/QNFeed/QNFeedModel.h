//
//  QNFeedModel.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNFeedModel : QNBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *time;
@property (nonatomic, copy, readonly) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
