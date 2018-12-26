//
//  QNLayoutDiv.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNLayoutDiv.h"
#import "QNLayout+Private.h"
#import "UIView+QNLayout.h"
#import "QNAsyncLayoutTransaction.h"

@interface QNLayoutDiv()
@property(nonatomic, strong) NSMutableArray *children;
@property(nonatomic, strong) QNLayout *qn_layout;

@end

@implementation QNLayoutDiv

- (instancetype)init {
    if (self = [super init]) {
        self.children = [NSMutableArray array];
        self.qn_layout = [QNLayout new];
        self.qn_layout.context = self;
    }
    return self;
}

+ (instancetype)linearDivWithLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:layout];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.eq(QNFlexDirectionRow);
    }];
    return layoutDiv;
}

+ (instancetype)verticalDivWithLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:layout];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.eq(QNFlexDirectionColumn);
    }];
    return layoutDiv;
}

+ (instancetype)absoluteLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:layout];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        layout.absoluteLayout();
    }];
    return layoutDiv;
}

+ (instancetype)layoutDivWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                  children:(NSArray<id<QNLayoutProtocol>>*)children {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        [layout setFlexDirection:direction];
        [layout setJustifyContent:justifyContent];
    }];
    [layoutDiv setQn_children:children];
    return layoutDiv;
}

+ (instancetype)layoutDivWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                alignItems:(QNAlign)alignItems
                                  children:(NSArray <id<QNLayoutProtocol>>*)children {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        [layout setFlexDirection:direction];
        [layout setJustifyContent:justifyContent];
        [layout setAlignItems:alignItems];
    }];
    [layoutDiv setQn_children:children];
    return layoutDiv;
}

- (void)setQn_children:(NSArray<id<QNLayoutProtocol>> *)children {
    if (self.children == children) {
        return;
    }
    self.children = [children mutableCopy];
    [self.qn_layout removeAllChildren];
    
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [self.qn_layout addChild:layoutElement.qn_layout];
    }
}

- (NSArray *)qn_children {
    return self.children ? [self.children copy] : @[];
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [self.children mutableCopy];
    [newChildren addObject:layout];
    self.qn_children = newChildren;
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    [newChildren addObjectsFromArray:children];
    self.qn_children = newChildren;
}

- (void)qn_layoutWithSize:(CGSize)size {
    self.qn_layout.wrapContent();
    [self.qn_layout resetUndefinedSize];
    [self.qn_layout calculateLayoutWithSize:size];
    self.frame = self.qn_layout.frame;
    [self qn_applyLayoutToViewHierachy];
}


- (void)qn_applyLayoutToViewHierachy {
    for (id<QNLayoutProtocol> layoutElement in self.children) {
        
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

- (void)qn_asyncLayoutWithSize:(CGSize)size {
    [QNAsyncLayoutTransaction addCalculateBlock:^{
        [self.qn_layout calculateLayoutWithSize:size];
    } complete:^{
        self.frame = self.qn_layout.frame;
        [self qn_applyLayoutToViewHierachy];
    }];
}

- (QNLayout *)qn_makeLayout:(void (^)(QNLayout *))layout {
    if (layout) {
        layout(self.qn_layout);
    }
    return self.qn_layout;
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
}

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout {
    [self.children removeObject:layout];
    self.qn_children = [self.children copy];
}

@end
