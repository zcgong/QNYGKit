//
//  UIView+ZJ.m
//  ZuJi
//
//  Created by huiyanliu on 2018/9/25.
//  Copyright © 2018年 Zhengjie Huan. All rights reserved.
//

#import "UIView+ZJ.h"

@implementation UIView (ZJ)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGPoint)bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

-(CGFloat)width{
    CGRect rect = self.frame;
    return rect.size.width;
}

-(void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

-(CGFloat)height{
    CGRect rect = self.frame;
    return rect.size.height;
}

-(void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

-(CGFloat)top{
    CGRect rect = self.frame;
    return rect.origin.y;
}

-(void)setTop:(CGFloat)top{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

-(CGFloat)left{
    CGRect rect = self.frame;
    return rect.origin.x;
}

-(void)setLeft:(CGFloat)left{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

-(CGFloat)bottom{
    CGRect rect = self.frame;
    return rect.origin.y + rect.size.height;
}

-(void)setBottom:(CGFloat)bottom{
    CGRect rect = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}

-(CGFloat)right{
    CGRect rect = self.frame;
    return rect.origin.x + rect.size.width;
}

-(void)setRight:(CGFloat)right{
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerY{
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
@end
