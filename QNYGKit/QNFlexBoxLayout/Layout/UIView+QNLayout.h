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

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QNLayout)<QNLayoutProtocol, QNLayoutCalProtocol>

/**
 固定宽度的布局
 */
- (void)qn_layoutWithFixedWidth;

/**
 固定高度的布局
 */
- (void)qn_layoutWithFixedHeight;

/**
 固定size的布局
 */
- (void)qn_layoutWithFixedSize;

/**
 根据给定的尺寸布局，不改变view的origin坐标
 */
- (void)qn_layoutOriginWithSize:(CGSize)size;

/**
 根据给定的尺寸异步布局，不改变view的origin坐标
 */
- (void)qn_asyncLayoutOriginWithSize:(CGSize)size;

- (void)qn_setFlexDirection:(QNFlexDirection)direction
             justifyContent:(QNJustify)justifyContent
                 alignItems:(QNAlign)alignItems
                   children:(NSArray<id<QNLayoutProtocol>>*)children;

@end

NS_ASSUME_NONNULL_END
