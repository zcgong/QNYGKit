//
//  QNLayoutVirtualView.m
//  QQNews
//
//  Created by jayhuan on 2019/1/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QNLayoutVirtualView.h"
#import "QNLayout+Private.h"
#import "UIView+QNLayout.h"
#import "QNAsyncLayoutTransaction.h"

@interface QNLayoutVirtualView()
@property(nonatomic, strong) QNLayout *qn_layout;
@property(nonatomic, copy) NSArray<id<QNLayoutProtocol>> *qn_children;
@end

@implementation QNLayoutVirtualView

- (instancetype)init {
    if (self = [super init]) {
        self.qn_layout = [QNLayout new];
        self.qn_layout.context = self;
    }
    return self;
}

+ (instancetype)linearLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutVirtualView *layoutVirtualView = [self new];
    [layoutVirtualView qn_makeLayout:layout];
    [layoutVirtualView qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection(QNFlexDirectionRow);
    }];
    return layoutVirtualView;
}

+ (instancetype)verticalLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutVirtualView *layoutVirtualView = [self new];
    [layoutVirtualView qn_makeLayout:layout];
    return layoutVirtualView;
}

+ (instancetype)absoluteLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutVirtualView *layoutVirtualView = [self new];
    [layoutVirtualView qn_makeLayout:layout];
    [layoutVirtualView qn_makeLayout:^(QNLayout *layout) {
        layout.absoluteLayout();
    }];
    return layoutVirtualView;
}

+ (instancetype)layoutWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                  children:(NSArray<id<QNLayoutProtocol>>*)children {
    QNLayoutVirtualView *layoutVirtualView = [self new];
    [layoutVirtualView qn_makeLayout:^(QNLayout *layout) {
        [layout setFlexDirection:direction];
        [layout setJustifyContent:justifyContent];
    }];
    [layoutVirtualView p_updateChildren:children];
    return layoutVirtualView;
}

+ (instancetype)layoutWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                alignItems:(QNAlign)alignItems
                                  children:(NSArray <id<QNLayoutProtocol>>*)children {
    QNLayoutVirtualView *layoutVirtualView = [self new];
    [layoutVirtualView qn_makeLayout:^(QNLayout *layout) {
        [layout setFlexDirection:direction];
        [layout setJustifyContent:justifyContent];
        [layout setAlignItems:alignItems];
    }];
    [layoutVirtualView p_updateChildren:children];
    return layoutVirtualView;
}

- (void)p_updateChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    if (self.qn_children == children) {
        return;
    }
    self.qn_children = [children copy];
    [self.qn_layout removeAllChildren];
    
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [self.qn_layout addChild:layoutElement.qn_layout];
    }
}

- (NSUInteger)qn_childrenCount {
    return self.qn_children.count;
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [self p_newChildren];
    [newChildren addObject:layout];
    [self p_updateChildren:[newChildren copy]];
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSMutableArray *newChildren = [self p_newChildren];
    [newChildren addObjectsFromArray:children];
    [self p_updateChildren:[newChildren copy]];
}

- (void)qn_layoutWithSize:(CGSize)size {
    CGSize oriSize = size;
    if (oriSize.width <= 0) {
        oriSize.width = QNUndefinedValue;
    }
    
    if (oriSize.height <= 0) {
        oriSize.height = QNUndefinedValue;
    }
    [self qn_layout].wrapContent();
    [self.qn_layout calculateLayoutWithSize:oriSize];
    self.frame = self.qn_layout.frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_layoutWithWrapContent {
    [self qn_layoutWithSize:QNUndefinedSize];
}

- (void)qn_asyncLayoutWithSize:(CGSize)size complete:(void (^)(CGRect frame))complete {
    CGSize oriSize = size;
    if (oriSize.width <= 0) {
        oriSize.width = QNUndefinedValue;
    }
    
    if (oriSize.height <= 0) {
        oriSize.height = QNUndefinedValue;
    }
    [QNAsyncLayoutTransaction addCalculateBlock:^{
        [self.qn_layout calculateLayoutWithSize:oriSize];
    } complete:^{
        self.frame = self.qn_layout.frame;
        [self qn_applyLayoutToViewHierachy];
        if (complete) {
            complete(self.frame);
        }
    }];
}

- (void)qn_applyLayoutToViewHierachy {
    for (id<QNLayoutProtocol> layoutElement in self.qn_children) {
        layoutElement.frame = (CGRect) {
            .origin = {
                .x = _frame.origin.x + layoutElement.qn_layout.frame.origin.x,
                .y = _frame.origin.y + layoutElement.qn_layout.frame.origin.y,
            },
            .size = {
                .width = layoutElement.qn_layout.frame.size.width,
                .height = layoutElement.qn_layout.frame.size.height,
            },
        };
        layoutElement.calculated = YES;
        [self p_updateAbsoluteSubLayoutElementFrame:layoutElement];
        [layoutElement qn_applyLayoutToViewHierachy];
    }
}

- (void)p_updateAbsoluteSubLayoutElementFrame:(id<QNLayoutProtocol>)layoutElement {
    YGNodeRef node = layoutElement.qn_layout.qnNode;
    if (YGNodeStyleGetPositionType(node) != YGPositionTypeAbsolute) {
        return;
    }
    if (YGNodeStyleGetAlignSelf(node) == YGAlignCenter) {
        if (YGNodeStyleGetDirection(node) == YGFlexDirectionRow) {
            CGFloat y = (CGRectGetHeight(self.frame) - CGRectGetHeight(layoutElement.frame)) / 2;
            y += self.frame.origin.y;
            layoutElement.frame = CGRectMake(CGRectGetMinX(layoutElement.frame), y, CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        } else if (YGNodeStyleGetDirection(node) == YGFlexDirectionColumn) {
            CGFloat x = (CGRectGetWidth(self.frame) - CGRectGetWidth(layoutElement.frame)) / 2;
            x += self.frame.origin.x;
            layoutElement.frame = CGRectMake(x, CGRectGetMinY(layoutElement.frame), CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        }
    } else if (YGNodeStyleGetAlignSelf(node) == YGAlignFlexEnd) {
        if (YGNodeStyleGetDirection(node) == YGFlexDirectionRow) {
            CGFloat y = CGRectGetHeight(self.frame) - CGRectGetHeight(layoutElement.frame);
            CGFloat marginB = YGNodeStyleGetMargin(node, YGEdgeBottom);
            if (!YGValueIsUndefined(marginB)) {
                y -= marginB;
            }
            y += self.frame.origin.y;
            layoutElement.frame = CGRectMake(CGRectGetMinX(layoutElement.frame), y, CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        } else if (YGNodeStyleGetDirection(node) == YGFlexDirectionColumn) {
            CGFloat x = CGRectGetWidth(self.frame) - CGRectGetWidth(layoutElement.frame);
            CGFloat marginR = YGNodeStyleGetMargin(node, YGEdgeRight);
            if (!YGValueIsUndefined(marginR)) {
                x -= marginR;
            }
            x += self.frame.origin.x;
            layoutElement.frame = CGRectMake(x, CGRectGetMinY(layoutElement.frame), CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        }
    }
}

- (id<QNLayoutProtocol>)qn_childLayoutAtIndex:(NSUInteger)index {
    return [self.qn_children objectAtIndex:index];
}

- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index {
    NSMutableArray *newChildren = [self p_newChildren];
    [newChildren insertObject:layout atIndex:index];
    [self p_updateChildren:[newChildren copy]];
}

- (QNLayout *)qn_makeLayout:(void (^)(QNLayout *))layout {
    if (layout) {
        layout(self.qn_layout);
    }
    return self.qn_layout;
}

- (void)qn_markDirty {
    [self.qn_layout markDirty];
}

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout {
    NSMutableArray *newChildren = [self p_newChildren];
    if ([newChildren containsObject:layout]) {
        [newChildren removeObject:layout];
        [self p_updateChildren:[newChildren copy]];
    } else {
        NSAssert(NO, @"delete an invalid chlid");
    }
}

- (NSMutableArray *)p_newChildren {
    return self.qn_children ? [self.qn_children mutableCopy] : [NSMutableArray array];
}


@end
