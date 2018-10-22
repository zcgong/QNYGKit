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

typedef NS_ENUM(NSInteger, QNYGViewLayoutType) {
    kQNYGViewLayoutTypeWrap,
    kQNYGViewLayoutTypeWidth,
    kQNYGViewLayoutTypeHeight,
    kQNYGViewLayoutTypeSize
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QNLayout)<QNLayoutProtocol, QNLayoutCalProtocol>
- (void)qn_layoutWithLayoutType:(QNYGViewLayoutType)layoutType;
- (void)qn_layoutWithFixedWidth;
- (void)qn_layoutWithFixedHeight;
- (void)qn_layoutWithFixedSize;

//- (void)qn_layoutOriginWithLayoutType:(QNYGViewLayoutType)layoutType;
//- (void)qn_layoutOriginWithWrapContent;
//- (void)qn_layoutOriginWithFixedWidth;
//- (void)qn_layoutOriginWithFixedHeight;
//- (void)qn_layoutOriginWithFixedSize;

- (void)qn_layoutOriginWithSize:(CGSize)size;
- (void)qn_asyncLayoutOriginWithSize:(CGSize)size;

- (void)qn_setFlexDirection:(QNFlexDirection)direction
             justifyContent:(QNJustify)justifyContent
                 alignItems:(QNAlign)alignItems
                   children:(NSArray<id<QNLayoutProtocol>>*)children;

@end

NS_ASSUME_NONNULL_END
