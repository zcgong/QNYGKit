//
//  UIImageView+Chainable.h
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Chainable)

- (__kindof UIImageView * (^)(UIColor *color))bgColor;
- (__kindof UIImageView * (^)(CGFloat radius))cornerRadius;
- (__kindof UIImageView * (^)(UIImage *image))img;
- (__kindof UIImageView * (^)(NSString *imageName))imgName;
- (__kindof UIImageView * (^)(CGFloat alpha))a;
- (__kindof UIImageView * (^)(void))show;
- (__kindof UIImageView * (^)(void))hide;
- (__kindof UIImageView * (^)(void))enable;
- (__kindof UIImageView * (^)(void))disable;

@end

NS_ASSUME_NONNULL_END
