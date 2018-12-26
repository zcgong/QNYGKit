//
//  UIView+Chainable.h
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Chainable)

- (__kindof UIView * (^)(UIColor *color))bgColor;
- (__kindof UIView * (^)(CGFloat radius))cornerRadius;
- (__kindof UIView * (^)(CGFloat alpha))a;
- (__kindof UIView * (^)(void))show;
- (__kindof UIView * (^)(void))hide;
- (__kindof UIView * (^)(void))enable;
- (__kindof UIView * (^)(void))disable;
- (void)qn_addSubviews:(NSArray *)subViews;
- (void)qn_centerTo:(UIView *)view;
- (void)qn_centerToX:(UIView *)view;
- (void)qn_centerToY:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
