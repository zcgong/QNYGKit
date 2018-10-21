//
//  QNLayout+Private.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/25.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNLayout.h"
#import "Yoga.h"
#import "QNLayoutCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNLayout (Private)

@property(nonatomic, weak) id context;

@property(nonatomic, weak) QNLayout *parent;

@property(nonatomic, copy) NSDictionary *qnStyles;

@property(nonatomic, assign) YGNodeRef qnNode;

@property(nonatomic, assign) CGRect frame;

- (NSArray *)allChildren;

- (void)addChild:(QNLayout *)layout;

- (void)addChildren:(NSArray *)children;

- (void)insertChild:(QNLayout *)layout atIndex:(NSInteger)index;

- (QNLayout *)childLayoutAtIndex:(NSUInteger)index;

- (void)removeChild:(QNLayout *)layout;

- (void)removeAllChildren;

- (void)calculateLayoutWithSize:(CGSize)size;

- (void)setDirection:(QNDirection)direction;

- (void)setFlexDirection:(QNFlexDirection)flexDirection;

- (void)setJustifyContent:(QNJustify)justifyContent;

- (void)setAlignContent:(QNAlign)alignContent;

- (void)setAlignItems:(QNAlign)alignItems;

- (void)setAlignSelf:(QNAlign)alignSelf;

- (void)setPositionType:(QNPositionType)positionType;

- (void)setFlexWrap:(QNWrap)flexWrap;

- (void)setFlexGrow:(CGFloat)flexGrow;

- (void)setFlexShrink:(CGFloat)flexShrink;

- (void)setFlexBasis:(CGFloat)flexBasis;

- (void)setPosition:(CGFloat)position forEdge:(QNEdge)edge;

- (void)setMargin:(CGFloat)margin forEdge:(QNEdge)edge;

- (void)setPadding:(CGFloat)padding forEdge:(QNEdge)edge;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setSize:(CGSize)size;

- (void)setMinWidth:(CGFloat)minWidth;

- (void)setMinHeight:(CGFloat)minHeight;

- (void)setMinSize:(CGSize)minSize;

- (void)setMaxWidth:(CGFloat)maxWidth;

- (void)setMaxHeight:(CGFloat)maxHeight;

- (void)setMaxSize:(CGSize)maxSize;

- (void)setAspectRatio:(CGFloat)aspectRatio;

@end

NS_ASSUME_NONNULL_END
