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

@property(nonatomic, strong) NSMutableArray *styleNames;

@property(nonatomic, weak) id context;

@property(nonatomic, weak) QNLayout *parent;

@property(nonatomic, copy) NSDictionary *QNStyles;

@property(nonatomic, assign) YGNodeRef qnNode;

@property(nonatomic, assign) CGRect frame;

@end

@implementation QNLayout

- (instancetype)init {
    if (self = [super init]) {
        self.qnNode = YGNodeNew();
        self.mChildren = [NSMutableArray array];
        self.styleNames = [NSMutableArray array];
    }
    return self;
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
    if (view.qn_children.count != layoutCache.subLayoutCaches.count) {
        return;
    }
    
    for (int i = 0; i < layoutCache.subLayoutCaches.count; i++) {
        QNLayoutCache* childLayoutCache = layoutCache.subLayoutCaches[i];
        id<QNLayoutProtocol> childView = view.qn_children[i];
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

#define QN_STYLE_FILL(key)\
do {\
id value = self.qnStyles[@"QN"#key"AttributeName"];\
if (value) {\
[self set##key:[(NSNumber *)value floatValue]];\
}\
} while(0);

#define QN_STYLE_FILL_ALL_DIRECTION(key) \
do {\
id value = self.qnStyles[@"QN"#key"AttributeName"];\
if (value) {\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].left forEdge:QNEdgeLeft];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].top forEdge:QNEdgeTop];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].right forEdge:QNEdgeRight];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].bottom forEdge:QNEdgeBottom];\
}\
} while(0);

#define QN_STYLE_FILL_ALL_SIZE(key) \
do {\
id value = self.qnStyles[@"QN"#key"AttributeName"];\
if (value) {\
[self set##key:[(NSValue *)value CGSizeValue]];\
}\
} while(0);

- (void)setQNStyles:(NSDictionary *)qnStyles {
    
    if (self.qnStyles == qnStyles) {
        return;
    }
    self.qnStyles = qnStyles;
    QN_STYLE_FILL(Direction)
    QN_STYLE_FILL(FlexDirection)
    QN_STYLE_FILL(JustifyContent)
    QN_STYLE_FILL(AlignContent)
    QN_STYLE_FILL(AlignItems)
    QN_STYLE_FILL(AlignSelf)
    QN_STYLE_FILL(PositionType)
    QN_STYLE_FILL(FlexWrap)
    QN_STYLE_FILL(FlexGrow)
    QN_STYLE_FILL(FlexShrink)
    QN_STYLE_FILL(FlexBasis)
    QN_STYLE_FILL_ALL_DIRECTION(Position)
    QN_STYLE_FILL_ALL_DIRECTION(Margin)
    QN_STYLE_FILL_ALL_DIRECTION(Padding)
    QN_STYLE_FILL(Width)
    QN_STYLE_FILL(Height)
    QN_STYLE_FILL(MinWidth)
    QN_STYLE_FILL(MinHeight)
    QN_STYLE_FILL(MaxWidth)
    QN_STYLE_FILL(MaxHeight)
    QN_STYLE_FILL(AspectRatio)
    QN_STYLE_FILL_ALL_SIZE(Size)
    QN_STYLE_FILL_ALL_SIZE(MinSize)
    QN_STYLE_FILL_ALL_SIZE(MaxSize)
}

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

#define CACHE_STYLES_NAME(name)  [self.styleNames addObject:@""#name]; \
return self;

- (QNLayout *)flexDirection {
    CACHE_STYLES_NAME(FlexDirection)
}

- (QNLayout *)justifyContent {
    CACHE_STYLES_NAME(JustifyContent)
}

- (QNLayout *)alignContent {
    CACHE_STYLES_NAME(AlignContent)
}

- (QNLayout *)alignItems {
    CACHE_STYLES_NAME(AlignItems)
}

- (QNLayout *)alignSelf {
    CACHE_STYLES_NAME(AlignSelf)
}

- (QNLayout *)positionType {
    CACHE_STYLES_NAME(PositionType)
}

- (QNLayout *)flexWrap {
    CACHE_STYLES_NAME(FlexWrap)
}

- (QNLayout *)flexGrow {
    CACHE_STYLES_NAME(FlexGrow)
}

- (QNLayout *)flexShrink {
    CACHE_STYLES_NAME(FlexShrink)
}

- (QNLayout *)flexBasiss {
    CACHE_STYLES_NAME(FlexBasiss)
}

- (QNLayout *)position {
    CACHE_STYLES_NAME(Position)
}

- (QNLayout *)margin {
    CACHE_STYLES_NAME(Margin)
}

- (QNLayout *)marginT {
    CACHE_STYLES_NAME(marginT);
}

- (QNLayout *)marginL {
    CACHE_STYLES_NAME(marginL);
}

- (QNLayout *)marginB {
    CACHE_STYLES_NAME(marginB);
}

- (QNLayout *)marginR {
    CACHE_STYLES_NAME(marginR);
}

- (QNLayout *)padding {
    CACHE_STYLES_NAME(Padding)
}

- (QNLayout *)paddingT {
    CACHE_STYLES_NAME(paddingT);
}

- (QNLayout *)paddingL {
    CACHE_STYLES_NAME(paddingL);
}

- (QNLayout *)paddingB {
    CACHE_STYLES_NAME(paddingB);
}

- (QNLayout *)paddingR {
    CACHE_STYLES_NAME(paddingR);
}

- (QNLayout *)width {
    CACHE_STYLES_NAME(Width)
}

- (QNLayout *)height {
    CACHE_STYLES_NAME(Height)
}

- (QNLayout *)minWidth {
    CACHE_STYLES_NAME(MinWidth)
}

- (QNLayout *)minHeight {
    CACHE_STYLES_NAME(MinHeight)
}

- (QNLayout *)maxWidth {
    CACHE_STYLES_NAME(MaxWidth)
}

- (QNLayout *)maxHeight {
    CACHE_STYLES_NAME(MaxHeight)
}

- (QNLayout *)maxSize {
    CACHE_STYLES_NAME(MaxSize)
}

- (QNLayout *)minSize {
    CACHE_STYLES_NAME(MinSize)
}

- (QNLayout *)aspectRatio {
    CACHE_STYLES_NAME(AspectRatio)
}

- (QNLayout *)size {
    CACHE_STYLES_NAME(Size)
}

#define QN_STYLE(key, value)\
do {\
if ([self.styleNames containsObject:@""#key]) {\
[self set##key:[(NSNumber *)value floatValue]];\
}\
} while(0);

#define QN_STYLE_ALL_DIRECTION(key, value) \
do {\
if ([self.styleNames containsObject:@""#key]) {\
[self set##key:value.left forEdge:QNEdgeLeft];\
[self set##key:value.top forEdge:QNEdgeTop];\
[self set##key:value.right forEdge:QNEdgeRight];\
[self set##key:value.bottom forEdge:QNEdgeBottom];\
}\
} while(0);

#define QN_STYLE_ALL_SIZE(key, value) \
do {\
if ([self.styleNames containsObject:@""#key]) {\
[self set##key:value];\
}\
} while(0);

- (QNLayout * (^)(id attr))equalTo {
    return ^QNLayout* (id attr) {
        if ([attr conformsToProtocol:NSProtocolFromString(@"QNLayoutProtocol")]) {
            YGNodeCopyStyle(self.qnNode, [(id<QNLayoutProtocol>)attr qn_layout].qnNode);
            return self;
        }
        QN_STYLE(Direction,attr)
        QN_STYLE(FlexDirection,attr)
        QN_STYLE(JustifyContent,attr)
        QN_STYLE(AlignContent,attr)
        QN_STYLE(AlignItems,attr)
        QN_STYLE(AlignSelf,attr)
        QN_STYLE(PositionType,attr)
        QN_STYLE(FlexWrap,attr)
        QN_STYLE(FlexGrow,attr)
        QN_STYLE(FlexShrink,attr)
        QN_STYLE(FlexBasis,attr)
        QN_STYLE(Width,attr)
        QN_STYLE(Height,attr)
        QN_STYLE(MinWidth,attr)
        QN_STYLE(MinHeight,attr)
        QN_STYLE(MaxWidth,attr)
        QN_STYLE(MaxHeight,attr)
        QN_STYLE(AspectRatio,attr)
        
        CGFloat value = [(NSNumber *)attr floatValue];
        if ([self.styleNames containsObject:@"marginT"]) {
            [self setMargin:value forEdge:QNEdgeTop];
        }
        if ([self.styleNames containsObject:@"marginL"]) {
            [self setMargin:value forEdge:QNEdgeLeft];
        }
        if ([self.styleNames containsObject:@"marginB"]) {
            [self setMargin:value forEdge:QNEdgeBottom];
        }
        if ([self.styleNames containsObject:@"marginR"]) {
            [self setMargin:value forEdge:QNEdgeRight];
        }
        
        if ([self.styleNames containsObject:@"paddingT"]) {
            [self setPadding:value forEdge:QNEdgeTop];
        }
        if ([self.styleNames containsObject:@"paddingL"]) {
            [self setPadding:value forEdge:QNEdgeLeft];
        }
        if ([self.styleNames containsObject:@"paddingB"]) {
            [self setPadding:value forEdge:QNEdgeBottom];
        }
        if ([self.styleNames containsObject:@"paddingR"]) {
            [self setPadding:value forEdge:QNEdgeRight];
        }
        
        [self.styleNames removeAllObjects];
        return self;
    };
}

- (QNLayout * (^)(CGSize attr))equalToSize {
    return ^QNLayout* (CGSize attr) {
        QN_STYLE_ALL_SIZE(Size,attr)
        QN_STYLE_ALL_SIZE(MinSize,attr)
        QN_STYLE_ALL_SIZE(MaxSize,attr)
        [self.styleNames removeAllObjects];
        return self;
    };
}

- (QNLayout * (^)(UIEdgeInsets attr))equalToEdgeInsets {
    return ^QNLayout* (UIEdgeInsets attr) {
        QN_STYLE_ALL_DIRECTION(Position,attr)
        QN_STYLE_ALL_DIRECTION(Margin,attr)
        QN_STYLE_ALL_DIRECTION(Padding,attr)
        [self.styleNames removeAllObjects];
        return self;
    };
}

- (QNLayout * (^)(void))wrapContent {
    return ^QNLayout* () {
        YGSetMesure(self);
        return self;
    };
}

- (QNLayout * (^)(void))wrapSize {
    return ^QNLayout* () {
        if ([self.context isKindOfClass:[UIView class]]) {
            [self setSize:((UIView *)(self.context)).frame.size];
        } else {
            NSAssert(NO, @"context is not view");
        }
        return self;
    };
}

- (QNLayout * (^)(void))wrapHeight {
    return ^QNLayout* () {
        if ([self.context isKindOfClass:[UIView class]]) {
            [self setSize:CGSizeMake(QNUndefinedValue, CGRectGetHeight(((UIView *)(self.context)).frame))];
            YGSetMesure(self);
        } else {
            NSAssert(NO, @"context is not view");
        }
        return self;
    };
}

- (QNLayout * (^)(void))wrapWidth {
    return ^QNLayout* () {
        if ([self.context isKindOfClass:[UIView class]]) {
            [self setSize:CGSizeMake(CGRectGetWidth(((UIView *)(self.context)).frame), QNUndefinedValue)];
            YGSetMesure(self);
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

- (QNLayout * (^)(void))spaceBetween {
    return ^QNLayout* () {
        [self setJustifyContent:QNJustifySpaceBetween];
        return self;
    };
}

- (QNLayout * (^)(void))justifyCenter {
    return ^QNLayout* () {
        [self setJustifyContent:QNJustifyCenter];
        return self;
    };
}

- (QNLayout * (^)(void))wrapExactContent {
    return ^QNLayout* () {
        if ([self.context conformsToProtocol:@protocol(QNLayoutCalProtocol)]) {
            CGSize currentSize = CGSizeMake(YGNodeStyleGetWidth(self.qnNode), YGNodeStyleGetHeight(self.qnNode));
            CGSize originSize = [((id<QNLayoutCalProtocol>)(self.context)) calculateSizeWithSize:QNUndefinedSize];
            [self setSize:CGSizeMake(currentSize.width == QNUndefinedValue ? originSize.width : currentSize.width, currentSize.height == QNUndefinedValue ? originSize.height : currentSize.height)];
        } else {
            NSAssert(NO, @"context is not view");
        }
        return self;
    };
}

- (QNLayout * (^)(void))absoluteLayout {
    return ^QNLayout* () {
        [self setPositionType:QNPositionTypeAbsolute];
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
