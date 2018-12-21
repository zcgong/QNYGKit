//
//  UILabel+Chainable.h
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Chainable)

- (__kindof UILabel * (^)(NSUInteger lineNum))lines;
- (__kindof UILabel * (^)(CGFloat font))fnt;
- (__kindof UILabel * (^)(UIColor *color))txtColor;
- (__kindof UILabel * (^)(UIColor *color))bgColor;
- (__kindof UILabel * (^)(NSString *text))txt;
- (__kindof UILabel * (^)(void))txtAlignCenter;
- (__kindof UILabel * (^)(NSTextAlignment alignment))txtAlign;
- (__kindof UILabel * (^)(CGFloat radius))cornerRadius;
- (__kindof UILabel * (^)(CGFloat alpha))a;
- (__kindof UILabel * (^)(void))show;
- (__kindof UILabel * (^)(void))hide;
- (__kindof UILabel * (^)(void))enable;
- (__kindof UILabel * (^)(void))disable;

@end

NS_ASSUME_NONNULL_END
