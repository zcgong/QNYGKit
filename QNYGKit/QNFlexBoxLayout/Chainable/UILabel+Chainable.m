//
//  UILabel+Chainable.m
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "UILabel+Chainable.h"

@implementation UILabel (Chainable)

- (__kindof UILabel * (^)(NSUInteger lineNum))lines {
    return ^UILabel *(NSUInteger lineNum) {
        self.numberOfLines = lineNum;
        return self;
    };
}

- (__kindof UILabel * (^)(CGFloat font))fnt {
    return ^UILabel * (CGFloat font) {
        self.font = [UIFont systemFontOfSize:font];
        return self;
    };
}

- (__kindof UILabel * (^)(UIColor *color))txtColor {
    return ^UILabel * (UIColor *color) {
        self.textColor = color;
        return self;
    };
}

- (__kindof UILabel * (^)(UIColor *color))bgColor {
    return ^UILabel * (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (__kindof UILabel * (^)(NSString *text))txt {
    return ^UILabel * (NSString *text) {
        self.text = text;
        return self;
    };
}

- (__kindof UILabel * (^)(void))txtAlignCenter {
    return ^UILabel * (void) {
        self.textAlignment = NSTextAlignmentCenter;
        return self;
    };
}

- (__kindof UILabel * (^)(NSTextAlignment alignment))txtAlign {
    return ^UILabel * (NSTextAlignment alignment) {
        self.textAlignment = alignment;
        return self;
    };
}

- (__kindof UILabel * (^)(CGFloat radius))cornerRadius {
    return ^UILabel * (CGFloat radius) {
        self.layer.cornerRadius = radius;
        return self;
    };
}

- (__kindof UILabel * (^)(CGFloat alpha))a {
    return ^UILabel * (CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}

- (__kindof UILabel * (^)(void))show {
    return ^UILabel * (void) {
        self.hidden = NO;
        return self;
    };
}

- (__kindof UILabel * (^)(void))hide {
    return ^UILabel * (void) {
        self.hidden = YES;
        return self;
    };
}

- (__kindof UILabel * (^)(void))enable {
    return ^UILabel * (void) {
        self.userInteractionEnabled = YES;
        return self;
    };
}

- (__kindof UILabel * (^)(void))disable {
    return ^UILabel * (void) {
        self.userInteractionEnabled = NO;
        return self;
    };
}

@end
