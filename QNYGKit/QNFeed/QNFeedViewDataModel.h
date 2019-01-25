//
//  QNFeedViewDataModel.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBaseDataModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNFeedViewDataModel : QNBaseDataModel

@property(nonatomic, strong) NSAttributedString *titleAttr;
@property(nonatomic, strong) NSAttributedString *contentAttr;
@property(nonatomic, strong) UIImage *contentImage;
@property(nonatomic, strong) NSAttributedString *nameAttr;
@property(nonatomic, strong) NSAttributedString *timeAttr;

@end

NS_ASSUME_NONNULL_END
