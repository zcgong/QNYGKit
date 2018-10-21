//
//  UIView+ZJ.h
//  ZuJi
//
//  Created by jayhuan on 2018/9/25.
//  Copyright © 2018年 Zhengjie Huan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (ZJ)

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGPoint origin;
@property CGSize size;

@property CGFloat height;
@property CGFloat width;
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

-(CGFloat)centerX;
-(void)setCenterX:(CGFloat)centerX;

-(CGFloat)centerY;
-(void)setCenterY:(CGFloat)centerY;

@end

NS_ASSUME_NONNULL_END
