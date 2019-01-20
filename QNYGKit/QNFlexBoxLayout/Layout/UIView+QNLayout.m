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

- (void)setCalculated:(BOOL)calculated {
    objc_setAssociatedObject(self, @selector(calculated), @(calculated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)calculated {
    NSNumber *calculatedNum = objc_getAssociatedObject(self, @selector(calculated));
    return [calculatedNum boolValue];
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    [newChildren addObject:layout];
    self.qn_children = [newChildren copy];
    [self qn_markDirty];
}

- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    [newChildren insertObject:layout atIndex:index];
    self.qn_children = [newChildren copy];
    [self qn_markDirty];
}

- (id<QNLayoutProtocol>)qn_childLayoutAtIndex:(NSUInteger)index {
    return [[self qn_children] objectAtIndex:index];
}

- (NSUInteger)qn_childrenCount {
    return self.qn_children.count;
}

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout {
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    if ([newChildren containsObject:layout]) {
        [layout.qn_layout markDirty];
        [newChildren removeObject:layout];
        self.qn_children = [newChildren copy];
    } else {
        NSAssert(NO, @"delete an invalid chlid");
    }
}

- (void)p_removeAllChildren {
    self.qn_children = nil;
}

- (QNLayout *)qn_makeLayout:(void(^)(QNLayout *layout))layout {
    if (layout) {
        QNLayout *mLayout = objc_getAssociatedObject(self, @selector(qn_layout));
        if (mLayout) {
            if (mLayout) {
                [self p_removeAllChildren];
                [mLayout reset];
                self.calculated = NO;
                mLayout.context = self;
            }
        }
        layout(self.qn_layout);
    }
    return self.qn_layout;
}

- (void)qn_markDirty {
    [self.qn_layout markDirty];
}

- (void)p_reLayout {
    [self qn_markDirty];
    for (id<QNLayoutProtocol> element in self.qn_children) {
        if (element.calculated) {
            element.qn_layout.wrapSize();   // 保持原计算尺寸
        }
    }
}

- (QNLayout *)qn_makeReLayout:(void(^)(QNLayout *layout))layout {
    [self qn_markDirty];
    if (layout) {
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
    CGSize oriSize = size;
    if (oriSize.width <= 0) {
        oriSize.width = QNUndefinedValue;
    }
    
    if (oriSize.height <= 0) {
        oriSize.height = QNUndefinedValue;
    }
    self.qn_layout.wrapContent();
    [self.qn_layout calculateLayoutWithSize:oriSize];
    self.frame = self.qn_layout.frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_asyncLayoutWithSize:(CGSize)size complete:(void(^)(CGRect frame))complete {
    CGSize oriSize = size;
    if (oriSize.width <= 0) {
        oriSize.width = QNUndefinedValue;
    }
    
    if (oriSize.height <= 0) {
        oriSize.height = QNUndefinedValue;
    }
    self.qn_layout.wrapContent();
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

- (void)qn_layoutOriginWithSize:(CGSize)size {
    CGPoint origin = self.frame.origin;
    [self qn_layoutWithSize:size];
    self.frame = (CGRect){origin, self.frame.size};
}

- (void)qn_reLayoutWithSize:(CGSize)size {
    [self p_reLayout];
    [self qn_layoutWithSize:size];
}

- (void)qn_reLayoutOriginWithSize:(CGSize)size {
    [self p_reLayout];
    [self qn_layoutOriginWithSize:size];
}

- (void)qn_applyLayoutToViewHierachy {
    for (id<QNLayoutProtocol> layoutElement in self.qn_children) {
        layoutElement.frame = layoutElement.qn_layout.frame;
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

- (BOOL)allowAsyncCalculated {
    return NO;
}

#pragma mark - private

- (void)p_layoutSize:(CGSize)size {
    CGRect newframe = self.frame;
    newframe.size = size;
    self.frame = newframe;
}

@end
