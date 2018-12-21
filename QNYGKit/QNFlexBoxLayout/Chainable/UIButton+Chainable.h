//
//  UIButton+Chainable.h
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Chainable)

- (__kindof UIButton * (^)(UIColor *color))bgColor;
- (__kindof UIButton * (^)(CGFloat radius))cornerRadius;
- (__kindof UIButton * (^)(CGFloat font))fnt;
- (__kindof UIButton * (^)(NSString *title))normalTitle;
- (__kindof UIButton * (^)(UIImage *image))normalImg;
- (__kindof UIButton * (^)(CGFloat alpha))a;
- (__kindof UIButton * (^)(void))show;
- (__kindof UIButton * (^)(void))hide;
- (__kindof UIButton * (^)(void))enable;
- (__kindof UIButton * (^)(void))disable;

@end

NS_ASSUME_NONNULL_END
