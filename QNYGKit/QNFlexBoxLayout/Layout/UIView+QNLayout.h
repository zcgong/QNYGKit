//
//  UIView+QNLayout.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNLayoutProtocol.h"

typedef NS_ENUM(NSInteger, QNYGViewLayoutType) {
    kQNYGViewLayoutTypeWrap,
    kQNYGViewLayoutTypeWidth,
    kQNYGViewLayoutTypeHeight,
    kQNYGViewLayoutTypeSize
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QNLayout)<QNLayoutProtocol>
- (void)qn_applyLayoutWithLayoutType:(QNYGViewLayoutType)layoutType;
- (void)qn_wrapContent;
- (void)qn_applyLayoutWithFixedWidth;
- (void)qn_applyLayoutWithFixedHeight;
- (void)qn_applyLayoutWithFixedSize;

- (void)qn_markAllowLayout;

- (void)qn_setFlexDirection:(QNFlexDirection)direction
             justifyContent:(QNJustify)justifyContent
                 alignItems:(QNAlign)alignItems
                   children:(NSArray<id<QNLayoutProtocol>>*)children;

@end

NS_ASSUME_NONNULL_END
