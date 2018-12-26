//
//  UIView+Chainable.m
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "UIView+Chainable.h"

@implementation UIView (Chainable)

- (__kindof UIView * (^)(UIColor *color))bgColor {
    return ^UIView * (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (__kindof UIView * (^)(CGFloat radius))cornerRadius {
    return ^UIView * (CGFloat radius) {
        self.layer.cornerRadius = radius;
        return self;
    };
}

- (__kindof UIView * (^)(CGFloat alpha))a {
    return ^UIView * (CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}

- (__kindof UIView * (^)(void))show {
    return ^UIView * (void) {
        self.hidden = NO;
        return self;
    };
}

- (__kindof UIView * (^)(void))hide {
    return ^UIView * (void) {
        self.hidden = YES;
        return self;
    };
}

- (__kindof UIView * (^)(void))enable {
    return ^UIView * (void) {
        self.userInteractionEnabled = YES;
        return self;
    };
}

- (__kindof UIView * (^)(void))disable {
    return ^UIView * (void) {
        self.userInteractionEnabled = NO;
        return self;
    };
}

- (void)qn_addSubviews:(NSArray *)subViews {
    if (subViews.count <= 0) {
        return;
    }
    for (id subView in subViews) {
        if ([subView isKindOfClass:[UIView class]]) {
            [self addSubview:subView];
        } else {
            NSAssert(NO, @"%@ is invalid view", subView);
        }
    }
}

- (void)qn_centerTo:(UIView *)view {
    self.center = view.center;
}

- (void)qn_centerToX:(UIView *)view {
    self.center = CGPointMake(view.center.x, self.center.y);
}

- (void)qn_centerToY:(UIView *)view {
    self.center = CGPointMake(self.center.x, view.center.y);
}

@end
