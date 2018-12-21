//
//  UIImageView+Chainable.m
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "UIImageView+Chainable.h"

@implementation UIImageView (Chainable)

- (__kindof UIImageView * (^)(UIColor *color))bgColor {
    return ^UIImageView * (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (__kindof UIImageView * (^)(CGFloat radius))cornerRadius {
    return ^UIImageView * (CGFloat radius) {
        self.layer.cornerRadius = radius;
        return self;
    };
}

- (__kindof UIImageView * (^)(UIImage *image))img {
    return ^UIImageView * (UIImage *image) {
        self.image = image;
        return self;
    };
}

- (__kindof UIImageView * (^)(NSString *imageName))imgName {
    return ^UIImageView * (NSString *imageName) {
        self.image = [UIImage imageNamed:imageName];
        return self;
    };
}

- (__kindof UIImageView * (^)(CGFloat alpha))a {
    return ^UIImageView * (CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}

- (__kindof UIImageView * (^)(void))show {
    return ^UIImageView * (void) {
        self.hidden = NO;
        return self;
    };
}

- (__kindof UIImageView * (^)(void))hide {
    return ^UIImageView * (void) {
        self.hidden = YES;
        return self;
    };
}

- (__kindof UIImageView * (^)(void))enable {
    return ^UIImageView * (void) {
        self.userInteractionEnabled = YES;
        return self;
    };
}

- (__kindof UIImageView * (^)(void))disable {
    return ^UIImageView * (void) {
        self.userInteractionEnabled = NO;
        return self;
    };
}

@end
