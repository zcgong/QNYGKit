//
//  UIView+QNLayout.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNLayoutProtocol.h"
#import "QNLayoutCalProtocol.h"

@interface UIView (QNLayout)<QNLayoutProtocol, QNLayoutCalProtocol>

/**
 线性布局
 */
- (QNLayout *)qn_makeLinearLayout:(void(^)(QNLayout *layout))layout;

/**
 垂直布局
 */
- (QNLayout *)qn_makeVerticalLayout:(void(^)(QNLayout *layout))layout;

/**
 绝对布局
 */
- (QNLayout *)qn_makeAbsoluteLayout:(void(^)(QNLayout *layout))layout;

/**
 固定宽度布局
 */
- (void)qn_layoutWithFixedWidth;

/**
 固定高度布局
 */
- (void)qn_layoutWithFixedHeight;

/**
 固定尺寸布局
 */
- (void)qn_layoutWithFixedSize;

/**
 根据size进行布局，保持frame放入origin不变
 
 @param size 尺寸参数
 */
- (void)qn_layoutOriginWithSize:(CGSize)size;

/**
 使用上次缓存的计算结果重新计算。（在增删改部分节点的场景使用）
 
 @param size 尺寸参数
 */
- (void)qn_reLayoutWithSize:(CGSize)size;

/**
 使用上次缓存的计算结果重新计算，保持frame的origin不变。（在增删改部分节点的场景使用）
 
 @param size 尺寸参数
 */
- (void)qn_reLayoutOriginWithSize:(CGSize)size;

/**
 标记已计算过的layout节点为待计算状态。（修改部分节点）
 */
- (QNLayout *)qn_makeReLayout:(void(^)(QNLayout *layout))layout;

@end
