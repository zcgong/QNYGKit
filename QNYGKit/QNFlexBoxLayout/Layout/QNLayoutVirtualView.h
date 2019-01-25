//
//  QNLayoutVirtualView.h
//  QQNews
//
//  Created by jayhuan on 2019/1/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNLayoutProtocol.h"

/**
 虚拟视图布局，方便布局，同时减少View的层级。支持完全使用VirtualView布局，与UIView完全等价。
 */
@interface QNLayoutVirtualView : NSObject<QNLayoutProtocol>

@property(nonatomic, assign) CGRect frame;
@property(nonatomic, assign) BOOL calculated;

/**
 线性布局VirtualView
 */
+ (instancetype)linearLayout:(void(^)( QNLayout *layout))layout;

/**
 垂直布局VirtualView
 */
+ (instancetype)verticalLayout:(void(^)( QNLayout *layout))layout;

/**
 绝对布局
 */
+ (instancetype)absoluteLayout:(void(^)(QNLayout *layout))layout;

/**
 根据布局方向、对齐方式、子元素自定义VirtualView
 
 @param direction 方向
 @param justifyContent 对齐方式（主轴）
 @param children 子元素
 */
+ (instancetype)layoutWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                  children:(NSArray<id<QNLayoutProtocol>>*)children;

/**
 根据布局方向、对齐方式、子元素自定义VirtualView
 
 @param direction 方向
 @param justifyContent 对齐方式（主轴）
 @param alignItems 对齐方式（交叉轴）
 @param children 子元素
 */
+ (instancetype)layoutWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                alignItems:(QNAlign)alignItems
                                  children:(NSArray<id<QNLayoutProtocol>>*)children;

@end
