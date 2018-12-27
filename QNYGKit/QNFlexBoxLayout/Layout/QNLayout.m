//
//  QNLayout.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNLayout.h"
#import "QNLayoutProtocol.h"
#import "QNLayout+Private.h"
#import "Yoga.h"
#import "QNLayoutCache.h"
#import "QNLayoutCalProtocol.h"

const CGSize QNUndefinedSize = {
    .width = YGUndefined,
    .height = YGUndefined,
};

const CGFloat QNUndefinedValue = YGUndefined;

static CGFloat QNRoundPixelValue(CGFloat value)
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    return round(value * scale) / scale;
}

static CGFloat YGSanitizeMeasurement(
                                     CGFloat constrainedSize,
                                     CGFloat measuredSize,
                                     YGMeasureMode measureMode)
{
    CGFloat result;
    if (measureMode == YGMeasureModeExactly) {
        result = constrainedSize;
    } else if (measureMode == YGMeasureModeAtMost) {
        result = MIN(constrainedSize, measuredSize);
    } else {
        result = measuredSize;
    }
    
    return result;
}


static YGSize YGMeasureView(
                            YGNodeRef node,
                            float width,
                            YGMeasureMode widthMode,
                            float height,
                            YGMeasureMode heightMode)
{
    const CGFloat constrainedWidth = (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
    const CGFloat constrainedHeight = (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX: height;
    
    id<QNLayoutCalProtocol> calLayout = (__bridge id<QNLayoutCalProtocol>) YGNodeGetContext(node);
    
    __block CGSize sizeThatFits;
    if ([[NSThread currentThread] isMainThread]) {
        sizeThatFits = [calLayout calculateSizeWithSize:(CGSize) {
            .width = constrainedWidth,
            .height = constrainedHeight,
        }];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            sizeThatFits = [calLayout calculateSizeWithSize:(CGSize) {
                .width = constrainedWidth,
                .height = constrainedHeight,
            }];
        });
    }
    
    return (YGSize) {
        .width = YGSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode),
        .height = YGSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode),
    };
}

static void YGSetMesure(QNLayout *layout) {
    if ([layout.context conformsToProtocol:@protocol(QNLayoutCalProtocol)] && layout.allChildren.count == 0) {
        YGNodeSetMeasureFunc(layout.qnNode, YGMeasureView);
    } else {
        YGNodeSetMeasureFunc(layout.qnNode, NULL);
    }
}

@interface QNLayout()

@property(nonatomic, strong) NSMutableArray *mChildren;
@property(nonatomic, weak) id context;
@property(nonatomic, weak) QNLayout *parent;
@property(nonatomic, assign) YGNodeRef qnNode;
@property(nonatomic, assign) CGRect frame;

@end

@implementation QNLayout

- (instancetype)init {
    if (self = [super init]) {
        self.qnNode = YGNodeNew();
    }
    return self;
}

- (NSMutableArray *)mChildren {
    if (!_mChildren) {
        _mChildren = [NSMutableArray array];
    }
    return _mChildren;
}

- (void)setContext:(id)context {
    _context = context;
    YGNodeSetContext(self.qnNode, (__bridge void *)(context));
}

- (void)dealloc {
    YGNodeFree(self.qnNode);
}

- (CGRect)frame {
    return CGRectMake(QNRoundPixelValue(YGNodeLayoutGetLeft(self.qnNode)),
                      QNRoundPixelValue(YGNodeLayoutGetTop(self.qnNode)),
                      QNRoundPixelValue(YGNodeLayoutGetWidth(self.qnNode)),
                      QNRoundPixelValue(YGNodeLayoutGetHeight(self.qnNode)));
}

- (QNLayoutCache *)layoutCache {
    QNLayoutCache *layoutCache = [QNLayoutCache new];
    layoutCache.frame = ((id<QNLayoutProtocol>)self.context).frame;
    NSMutableArray *childrenLayoutCache = [NSMutableArray arrayWithCapacity:self.allChildren.count];
    for (QNLayout *childLayout in self.allChildren) {
        [childrenLayoutCache addObject:[childLayout layoutCache]];
    }
    layoutCache.subLayoutCaches = [childrenLayoutCache copy];
    return layoutCache;
}


- (void)applyLayoutCache:(QNLayoutCache *)layoutCache {
    id<QNLayoutProtocol> view = self.context;
    view.frame = layoutCache.frame;
    if (view.qn_childrenCount != layoutCache.subLayoutCaches.count) {
        return;
    }
    
    for (int i = 0; i < layoutCache.subLayoutCaches.count; i++) {
        QNLayoutCache* childLayoutCache = layoutCache.subLayoutCaches[i];
        id<QNLayoutProtocol> childView = [view qn_childLayoutAtIndex:i];
        [childView.qn_layout applyLayoutCache:childLayoutCache];
    }
}

#pragma mark - children

- (NSArray *)allChildren {
    return [self.mChildren copy];
}

- (QNLayout *)childLayoutAtIndex:(NSUInteger)index {
    return [self.mChildren objectAtIndex:index];
}

- (void)addChild:(QNLayout *)layout {
    [self.mChildren addObject:layout];
    layout.parent = self;
    
    YGNodeInsertChild(self.qnNode, layout.qnNode, YGNodeGetChildCount(self.qnNode));
    
}

- (void)addChildren:(NSArray *)children {
    for (QNLayout *layout in children) {
        [self addChild:layout];
    }
}

- (void)insertChild:(QNLayout *)layout atIndex:(NSInteger)index {
    [self.mChildren insertObject:layout atIndex:index];
    layout.parent = self;
    YGNodeInsertChild(self.qnNode, layout.qnNode, (uint32_t)index);
}

- (void)removeChild:(QNLayout *)layout {
    [self.mChildren removeObject:layout];
    YGNodeRemoveChild(self.qnNode, layout.qnNode);
}

- (void)removeAllChildren {
    [self.mChildren removeAllObjects];
    if (self.qnNode == NULL) {
        return;
    }
    
    while (YGNodeGetChildCount(self.qnNode) > 0) {
        YGNodeRemoveChild(self.qnNode, YGNodeGetChild(self.qnNode, YGNodeGetChildCount(self.qnNode) - 1));
    }
}

#pragma mark - calculate

- (void)calculateLayoutWithSize:(CGSize)size {
    YGNodeCalculateLayout(self.qnNode,
                          size.width,
                          size.height,
                          YGNodeStyleGetDirection(self.qnNode));
}

#pragma mark - QN styles

- (void)setDirection:(QNDirection)direction
{
    YGNodeStyleSetDirection(self.qnNode, (YGDirection)direction);
}

- (void)setFlexDirection:(QNFlexDirection)flexDirection
{
    YGNodeStyleSetFlexDirection(self.qnNode, (YGFlexDirection)flexDirection);
}

- (void)setJustifyContent:(QNJustify)justifyContent
{
    YGNodeStyleSetJustifyContent(self.qnNode, (YGJustify)justifyContent);
}

- (void)setAlignContent:(QNAlign)alignContent
{
    YGNodeStyleSetAlignContent(self.qnNode, (YGAlign)alignContent);
}

- (void)setAlignItems:(QNAlign)alignItems
{
    YGNodeStyleSetAlignItems(self.qnNode, (YGAlign)alignItems);
}

- (void)setAlignSelf:(QNAlign)alignSelf
{
    YGNodeStyleSetAlignSelf(self.qnNode, (YGAlign)alignSelf);
}

- (void)setPositionType:(QNPositionType)positionType
{
    YGNodeStyleSetPositionType(self.qnNode, (YGPositionType)positionType);
}

- (void)setFlexWrap:(QNWrap)flexWrap
{
    YGNodeStyleSetFlexWrap(self.qnNode, (YGWrap)flexWrap);
}

- (void)setFlexGrow:(CGFloat)flexGrow
{
    YGNodeStyleSetFlexGrow(self.qnNode, flexGrow);
}

- (void)setFlexShrink:(CGFloat)flexShrink
{
    YGNodeStyleSetFlexShrink(self.qnNode, flexShrink);
}

- (void)setFlexBasis:(CGFloat)flexBasis
{
    YGNodeStyleSetFlexBasis(self.qnNode, flexBasis);
}

- (void)setPosition:(CGFloat)position forEdge:(QNEdge)edge
{
    YGNodeStyleSetPosition(self.qnNode, (YGEdge)edge, position);
}

- (void)setMargin:(CGFloat)margin forEdge:(QNEdge)edge
{
    YGNodeStyleSetMargin(self.qnNode, (YGEdge)edge, margin);
}

- (void)setPadding:(CGFloat)padding forEdge:(QNEdge)edge
{
    YGNodeStyleSetPadding(self.qnNode, (YGEdge)edge, padding);
}

- (void)setWidth:(CGFloat)width
{
    YGNodeStyleSetWidth(self.qnNode, width);
}

- (void)setHeight:(CGFloat)height
{
    YGNodeStyleSetHeight(self.qnNode, height);
}

- (void)setSize:(CGSize)size {
    YGNodeStyleSetWidth(self.qnNode, size.width);
    YGNodeStyleSetHeight(self.qnNode, size.height);
}

- (void)setMinWidth:(CGFloat)minWidth
{
    YGNodeStyleSetMinWidth(self.qnNode, minWidth);
}

- (void)setMinHeight:(CGFloat)minHeight
{
    YGNodeStyleSetMinHeight(self.qnNode, minHeight);
}

- (void)setMinSize:(CGSize)minSize {
    YGNodeStyleSetMinWidth(self.qnNode, minSize.width);
    YGNodeStyleSetMinHeight(self.qnNode, minSize.height);
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
    YGNodeStyleSetMaxWidth(self.qnNode, maxWidth);
}

- (void)setMaxHeight:(CGFloat)maxHeight
{
    YGNodeStyleSetMaxHeight(self.qnNode, maxHeight);
}

- (void)setMaxSize:(CGSize)maxSize {
    YGNodeStyleSetMaxWidth(self.qnNode, maxSize.width);
    YGNodeStyleSetMaxHeight(self.qnNode, maxSize.height);
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    YGNodeStyleSetAspectRatio(self.qnNode, aspectRatio);
}

- (void)resetUndefinedSize {
    [self setSize:QNUndefinedSize];
}

- (QNLayout * (^)(QNFlexDirection attr))flexDirection {
    return ^QNLayout* (QNFlexDirection attr) {
        [self setFlexDirection:attr];
        return self;
    };
}

- (QNLayout * (^)(QNJustify attr))justifyContent {
    return ^QNLayout* (QNJustify attr) {
        [self setJustifyContent:attr];
        return self;
    };
}

- (QNLayout * (^)(QNAlign attr))alignContent {
    return ^QNLayout* (QNAlign attr) {
        [self setAlignContent:attr];
        return self;
    };
}

- (QNLayout * (^)(QNAlign attr))alignItems {
    return ^QNLayout* (QNAlign attr) {
        [self setAlignItems:attr];
        return self;
    };
}

- (QNLayout * (^)(QNAlign attr))alignSelf {
    return ^QNLayout* (QNAlign attr) {
        [self setAlignSelf:attr];
        return self;
    };
}

- (QNLayout * (^)(QNPositionType attr))positionType {
    return ^QNLayout* (QNPositionType attr) {
        [self setPositionType:attr];
        return self;
    };
}

- (QNLayout * (^)(QNWrap attr))flexWrap {
    return ^QNLayout* (QNWrap attr) {
        [self setFlexWrap:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))flexGrow {
    return ^QNLayout* (CGFloat attr) {
        [self setFlexGrow:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))flexShrink {
    return ^QNLayout* (CGFloat attr) {
        [self setFlexShrink:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))flexBasiss {
    return ^QNLayout* (CGFloat attr) {
        [self setFlexBasis:attr];
        return self;
    };
}

- (QNLayout * (^)(UIEdgeInsets attr))position {
    return ^QNLayout* (UIEdgeInsets attr) {
        [self setPosition:attr.top forEdge:QNEdgeTop];
        [self setPosition:attr.left forEdge:QNEdgeLeft];
        [self setPosition:attr.bottom forEdge:QNEdgeBottom];
        [self setPosition:attr.right forEdge:QNEdgeRight];
        return self;
    };
}

- (QNLayout * (^)(UIEdgeInsets attr))margin {
    return ^QNLayout* (UIEdgeInsets attr) {
        [self setMargin:attr.top forEdge:QNEdgeTop];
        [self setMargin:attr.left forEdge:QNEdgeLeft];
        [self setMargin:attr.bottom forEdge:QNEdgeBottom];
        [self setMargin:attr.right forEdge:QNEdgeRight];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))marginT {
    return ^QNLayout* (CGFloat attr) {
        [self setMargin:attr forEdge:QNEdgeTop];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))marginL {
    return ^QNLayout* (CGFloat attr) {
        [self setMargin:attr forEdge:QNEdgeLeft];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))marginB {
    return ^QNLayout* (CGFloat attr) {
        [self setMargin:attr forEdge:QNEdgeBottom];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))marginR {
    return ^QNLayout* (CGFloat attr) {
        [self setMargin:attr forEdge:QNEdgeRight];
        return self;
    };
}

- (QNLayout * (^)(UIEdgeInsets attr))padding {
    return ^QNLayout* (UIEdgeInsets attr) {
        [self setPadding:attr.top forEdge:QNEdgeTop];
        [self setPadding:attr.left forEdge:QNEdgeLeft];
        [self setPadding:attr.bottom forEdge:QNEdgeBottom];
        [self setPadding:attr.right forEdge:QNEdgeRight];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))paddingT {
    return ^QNLayout* (CGFloat attr) {
        [self setPadding:attr forEdge:QNEdgeTop];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))paddingL {
    return ^QNLayout* (CGFloat attr) {
        [self setPadding:attr forEdge:QNEdgeLeft];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))paddingB {
    return ^QNLayout* (CGFloat attr) {
        [self setPadding:attr forEdge:QNEdgeBottom];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))paddingR {
    return ^QNLayout* (CGFloat attr) {
        [self setPadding:attr forEdge:QNEdgeRight];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))width {
    return ^QNLayout* (CGFloat attr) {
        [self setWidth:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))height {
    return ^QNLayout* (CGFloat attr) {
        [self setHeight:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))minWidth {
    return ^QNLayout* (CGFloat attr) {
        [self setMinWidth:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))minHeight {
    return ^QNLayout* (CGFloat attr) {
        [self setMinHeight:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))maxWidth {
    return ^QNLayout* (CGFloat attr) {
        [self setMaxWidth:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))maxHeight {
    return ^QNLayout* (CGFloat attr) {
        [self setMaxHeight:attr];
        return self;
    };
}

- (QNLayout * (^)(CGSize attr))size {
    return ^QNLayout* (CGSize attr) {
        [self setSize:attr];
        return self;
    };
}

- (QNLayout * (^)(CGSize attr))minSize {
    return ^QNLayout* (CGSize attr) {
        [self setMinSize:attr];
        return self;
    };
}

- (QNLayout * (^)(CGSize attr))maxSize {
    return ^QNLayout* (CGSize attr) {
        [self setMaxSize:attr];
        return self;
    };
}

- (QNLayout * (^)(CGFloat attr))aspectRatio {
    return ^QNLayout* (CGFloat attr) {
        [self setAspectRatio:attr];
        return self;
    };
}

- (QNLayout * (^)(void))wrapContent {
    return ^QNLayout* () {
        YGSetMesure(self);
        return self;
    };
}

- (QNLayout * (^)(void))wrapExactContent {
    return ^QNLayout* () {
        if ([self.context conformsToProtocol:@protocol(QNLayoutCalProtocol)] && self.allChildren.count == 0) {
            CGSize currentSize = CGSizeMake(YGNodeStyleGetWidth(self.qnNode), YGNodeStyleGetHeight(self.qnNode));
            CGSize originSize = [((id<QNLayoutCalProtocol>)(self.context)) calculateSizeWithSize:QNUndefinedSize];
            CGFloat paddingT = YGNodeStyleGetPadding(self.qnNode, YGEdgeTop);
            CGFloat paddingL = YGNodeStyleGetPadding(self.qnNode, YGEdgeLeft);
            CGFloat paddingB = YGNodeStyleGetPadding(self.qnNode, YGEdgeBottom);
            CGFloat paddingR = YGNodeStyleGetPadding(self.qnNode, YGEdgeRight);
            if (YGValueIsUndefined(paddingT)) {
                paddingT = 0;
            }
            if (YGValueIsUndefined(paddingL)) {
                paddingL = 0;
            }
            if (YGValueIsUndefined(paddingB)) {
                paddingB = 0;
            }
            if (YGValueIsUndefined(paddingR)) {
                paddingR = 0;
            }
            CGSize exactSize = CGSizeMake(YGValueIsUndefined(currentSize.width) ? originSize.width + (paddingL + paddingR) : currentSize.width, YGValueIsUndefined(currentSize.height) ? originSize.height + (paddingT + paddingB) : currentSize.height);
            [self setSize:exactSize];
            [self setMinSize:exactSize];
            [self setMaxSize:exactSize];
        } else {
            NSAssert(NO, @"context is not view");
        }
        return self;
    };
}

- (QNLayout * (^)(void))wrapSize {
    return ^QNLayout* () {
        if ([self.context isKindOfClass:[UIView class]]) {
            CGSize oriSize = ((UIView *)(self.context)).frame.size;
            if (oriSize.width <= 0) {
                oriSize.width = QNUndefinedValue;
            }
            
            if (oriSize.height <= 0) {
                oriSize.height = QNUndefinedValue;
            }
            [self setSize:oriSize];
        } else {
            NSAssert(NO, @"context is not view");
        }
        return self;
    };
}

- (QNLayout * (^)(void))alignSelfCenter {
    return ^QNLayout* () {
        [self setAlignSelf:QNAlignCenter];
        return self;
    };
}

- (QNLayout * (^)(void))alignSelfEnd {
    return ^QNLayout* () {
        [self setAlignSelf:QNAlignFlexEnd];
        return self;
    };
}

- (QNLayout * (^)(void))alignItemsCenter {
    return ^QNLayout* () {
        [self setAlignItems:QNAlignCenter];
        return self;
    };
}

- (QNLayout * (^)(void))justifyCenter {
    return ^QNLayout* () {
        [self setJustifyContent:QNJustifyCenter];
        return self;
    };
}

- (QNLayout * (^)(void))absoluteLayout {
    return ^QNLayout* () {
        [self setPositionType:QNPositionTypeAbsolute];
        return self;
    };
}

- (QNLayout * (^)(void))spaceBetween {
    return ^QNLayout* () {
        [self setJustifyContent:QNJustifySpaceBetween];
        return self;
    };
}

- (QNLayout * (^)(NSArray* children))children {
    return ^QNLayout* (NSArray* children) {
        [((id<QNLayoutProtocol>)self.context) qn_addChildren:children];
        return self;
    };
}

@end
