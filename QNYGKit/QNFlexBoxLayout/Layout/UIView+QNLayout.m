//
//  UIView+QNLayout.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "UIView+QNLayout.h"
#import <objc/runtime.h>
#import "QNLayout+Private.h"
#import "QNAsyncLayoutTransaction.h"

@interface UIView ()
@property(nonatomic, copy, setter=qn_setChildren:) NSArray<id<QNLayoutProtocol>> *qn_children;
@end

@implementation UIView (QNLayout)

- (QNLayout *)qn_makeLinearLayout:(void(^)(QNLayout *layout))layout {
    QNLayout *linearLayout = [self qn_makeLayout:layout];
    linearLayout.flexDirection(QNFlexDirectionRow);
    return linearLayout;
}

- (QNLayout *)qn_makeVerticalLayout:(void(^)(QNLayout *layout))layout {
    QNLayout *linearLayout = [self qn_makeLayout:layout];
    linearLayout.flexDirection(QNFlexDirectionColumn);
    return linearLayout;
}

- (QNLayout *)qn_makeAbsoluteLayout:(void(^)(QNLayout *layout))layout {
    QNLayout *absoluteLayout = [self qn_makeLayout:layout];
    absoluteLayout.absoluteLayout();
    return absoluteLayout;
}

- (void)qn_setChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    if (self.qn_children == children) {
        return;
    }
    objc_setAssociatedObject(self, @selector(qn_children), children, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.qn_layout removeAllChildren];
    
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [self.qn_layout addChild:layoutElement.qn_layout];
    }
}

- (NSArray *)qn_children {
    return objc_getAssociatedObject(self, _cmd) ?: @[];
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    [newChildren addObject:layout];
    self.qn_children = [newChildren copy];
}

- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    [newChildren insertObject:layout atIndex:index];
    self.qn_children = [newChildren copy];
}

- (id<QNLayoutProtocol>)qn_childLayoutAtIndex:(NSUInteger)index {
    return [[self qn_children] objectAtIndex:index];
}

- (NSUInteger)qn_childrenCount {
    return self.qn_children.count;
}

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout {
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    [newChildren removeObject:layout];
    self.qn_children = [newChildren copy];
}

- (void)p_removeAllChildren {
    self.qn_children = nil;
}

- (void)qn_markDirty {
    NSArray *children = [self qn_children];
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [layoutElement qn_markDirty];
    }
    [self p_removeAllChildren];
    objc_setAssociatedObject(self, @selector(qn_layout), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNLayout *)qn_makeLayout:(void(^)(QNLayout *layout))layout {
    if (layout) {
        QNLayout *mLayout = objc_getAssociatedObject(self, @selector(qn_layout));
        if (mLayout) {
            [self p_removeAllChildren];
            objc_setAssociatedObject(self, @selector(qn_layout), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        layout(self.qn_layout);
    }
    return self.qn_layout;
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren addObjectsFromArray:children];
    self.qn_children = [newChildren copy];
}

- (QNLayout *)qn_layout {
    QNLayout *layout = objc_getAssociatedObject(self, @selector(qn_layout));
    if (!layout) {
        layout = [QNLayout new];
        layout.context = self;
        objc_setAssociatedObject(self, @selector(qn_layout), layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return layout;
}

#pragma mark - layout

- (void)qn_layoutWithWrapContent {
    [self qn_layoutWithSize:QNUndefinedSize];
}

- (void)qn_layoutWithFixedWidth {
    [self qn_layoutWithSize:CGSizeMake(self.frame.size.width, QNUndefinedValue)];
}

- (void)qn_layoutWithFixedHeight {
    [self qn_layoutWithSize:CGSizeMake(QNUndefinedValue, self.frame.size.height)];
}

- (void)qn_layoutWithFixedSize {
    [self qn_layoutWithSize:self.frame.size];
}

- (void)qn_layoutWithSize:(CGSize)size {
    self.qn_layout.wrapContent();
    [self.qn_layout resetUndefinedSize];
    [self.qn_layout calculateLayoutWithSize:size];
    self.frame = self.qn_layout.frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_asyncLayoutWithSize:(CGSize)size {
    self.qn_layout.wrapContent();
    [self.qn_layout resetUndefinedSize];
    [QNAsyncLayoutTransaction addCalculateBlock:^{
        [self.qn_layout calculateLayoutWithSize:size];
    } complete:^{
        self.frame = self.qn_layout.frame;
        [self qn_applyLayoutToViewHierachy];
    }];
}

- (void)qn_layoutOriginWithSize:(CGSize)size {
    self.qn_layout.wrapContent();
    [self.qn_layout resetUndefinedSize];
    [self.qn_layout calculateLayoutWithSize:size];
    [self p_layoutSize:self.qn_layout.frame.size];
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_asyncLayoutOriginWithSize:(CGSize)size {
    self.qn_layout.wrapContent();
    [self.qn_layout resetUndefinedSize];
    [QNAsyncLayoutTransaction addCalculateBlock:^{
        [self.qn_layout calculateLayoutWithSize:size];
    } complete:^{
        [self p_layoutSize:self.qn_layout.frame.size];
        [self qn_applyLayoutToViewHierachy];
    }];
}

- (void)qn_applyLayoutToViewHierachy {
    for (id<QNLayoutProtocol> layoutElement in self.qn_children) {
        layoutElement.frame = layoutElement.qn_layout.frame;
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
        if (YGNodeStyleGetDirection(node) == YGFlexDirectionRow || YGNodeStyleGetDirection(node) == YGFlexDirectionRowReverse) {
            CGFloat y = (CGRectGetHeight(self.frame) - CGRectGetHeight(layoutElement.frame)) / 2;
            layoutElement.frame = CGRectMake(CGRectGetMinX(layoutElement.frame), y, CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        } else if (YGNodeStyleGetDirection(node) == YGFlexDirectionColumn || YGNodeStyleGetDirection(node) == YGFlexDirectionColumnReverse) {
            CGFloat x = (CGRectGetWidth(self.frame) - CGRectGetWidth(layoutElement.frame)) / 2;
            layoutElement.frame = CGRectMake(x, CGRectGetMinY(layoutElement.frame), CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        }
    } else if (YGNodeStyleGetAlignSelf(node) == YGAlignFlexEnd) {
        if (YGNodeStyleGetDirection(node) == YGFlexDirectionRow) {
            CGFloat y = CGRectGetHeight(self.frame) - CGRectGetHeight(layoutElement.frame);
            CGFloat marginB = YGNodeStyleGetMargin(node, YGEdgeBottom);
            if (!YGValueIsUndefined(marginB)) {
                y -= marginB;
            }
            layoutElement.frame = CGRectMake(CGRectGetMinX(layoutElement.frame), y, CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        } else if (YGNodeStyleGetDirection(node) == YGFlexDirectionColumn) {
            CGFloat x = CGRectGetWidth(self.frame) - CGRectGetWidth(layoutElement.frame);
            CGFloat marginR = YGNodeStyleGetMargin(node, YGEdgeRight);
            if (!YGValueIsUndefined(marginR)) {
                x -= marginR;
            }
            layoutElement.frame = CGRectMake(x, CGRectGetMinY(layoutElement.frame), CGRectGetWidth(layoutElement.frame), CGRectGetHeight(layoutElement.frame));
        }
    }
}

#pragma mark - QNLayoutCalProtocol

- (CGSize)calculateSizeWithSize:(CGSize)size {
    CGSize calSize = [self sizeThatFits:size];
    return CGSizeMake(ceil(calSize.width), ceil(calSize.height));
}

#pragma mark - private

- (void)p_layoutSize:(CGSize)size {
    CGRect newframe = self.frame;
    newframe.size = size;
    self.frame = newframe;
}

@end
