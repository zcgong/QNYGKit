//
//  QNLayoutDiv.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNLayoutProtocol.h"


/**
 Div布局，方便布局，同时减少View的层级
 */
@interface QNLayoutDiv : NSObject<QNLayoutProtocol>

@property(nonatomic, assign) CGRect frame;

/**
 线性布局Div
 */
+ (instancetype)linearDivWithLayout:(void(^)( QNLayout *layout))layout;

/**
 垂直布局Div
 */
+ (instancetype)verticalDivWithLayout:(void(^)( QNLayout *layout))layout;

/**
绝对布局
*/
+ (instancetype)absoluteLayout:(void(^)(QNLayout *layout))layout;

/**
 根据布局方向、对齐方式、子元素自定义Div
 
 @param direction 方向
 @param justifyContent 对齐方式（主轴）
 @param children 子元素
 */
+ (instancetype)layoutDivWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                  children:(NSArray<id<QNLayoutProtocol>>*)children;

/**
 根据布局方向、对齐方式、子元素自定义Div
 
 @param direction 方向
 @param justifyContent 对齐方式（主轴）
 @param alignItems 对齐方式（交叉轴）
 @param children 子元素
 */
+ (instancetype)layoutDivWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                alignItems:(QNAlign)alignItems
                                  children:(NSArray<id<QNLayoutProtocol>>*)children;

@end
