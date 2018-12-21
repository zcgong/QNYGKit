//
//  UIButton+Chainable.m
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "UIButton+Chainable.h"

@implementation UIButton (Chainable)

- (__kindof UIButton * (^)(UIColor *color))bgColor {
    return ^UIButton * (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (__kindof UIButton * (^)(CGFloat radius))cornerRadius {
    return ^UIButton * (CGFloat radius) {
        self.layer.cornerRadius = radius;
        return self;
    };
}

- (__kindof UIButton * (^)(CGFloat font))fnt {
    return ^UIButton * (CGFloat font) {
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        return self;
    };
}

- (__kindof UIButton * (^)(NSString *title))normalTitle {
    return ^UIButton * (NSString *title) {
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
}

- (__kindof UIButton * (^)(UIImage *image))normalImg {
    return ^UIButton * (UIImage *image) {
        [self setImage:image forState:UIControlStateNormal];
        return self;
    };
}

- (__kindof UIButton * (^)(CGFloat alpha))a {
    return ^UIButton * (CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}

- (__kindof UIButton * (^)(void))show {
    return ^UIButton * (void) {
        self.hidden = NO;
        return self;
    };
}

- (__kindof UIButton * (^)(void))hide {
    return ^UIButton * (void) {
        self.hidden = YES;
        return self;
    };
}

- (__kindof UIButton * (^)(void))enable {
    return ^UIButton * (void) {
        self.userInteractionEnabled = YES;
        return self;
    };
}

- (__kindof UIButton * (^)(void))disable {
    return ^UIButton * (void) {
        self.userInteractionEnabled = NO;
        return self;
    };
}

@end
