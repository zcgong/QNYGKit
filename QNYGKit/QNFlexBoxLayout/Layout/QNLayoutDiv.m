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
@property(nonatomic, strong) QNLayout *qn_layout;
@property(nonatomic, copy) NSArray<id<QNLayoutProtocol>> *qn_children;
@end

@implementation QNLayoutDiv

- (instancetype)init {
    if (self = [super init]) {
        self.qn_layout = [QNLayout new];
        self.qn_layout.context = self;
    }
    return self;
}

+ (instancetype)linearLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:layout];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection(QNFlexDirectionRow);
    }];
    return layoutDiv;
}

+ (instancetype)verticalLayout:(void(^)(QNLayout *layout))layout {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:layout];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection(QNFlexDirectionColumn);
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
    [layoutDiv p_updateChlidren:children];
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
    [layoutDiv p_updateChlidren:children];
    return layoutDiv;
}

- (void)p_updateChlidren:(NSArray<id<QNLayoutProtocol>> *)children {
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
    [self p_updateChlidren:[newChildren copy]];
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSMutableArray *newChildren = [self p_newChildren];
    [newChildren addObjectsFromArray:children];
    [self p_updateChlidren:[newChildren copy]];
}

- (void)qn_layoutWithSize:(CGSize)size {
    [self qn_layout].wrapContent();
    [[self qn_layout] resetUndefinedSize];
    [self.qn_layout calculateLayoutWithSize:size];
    self.frame = self.qn_layout.frame;
    [self qn_applyLayoutToViewHierachy];
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

- (id<QNLayoutProtocol>)qn_childLayoutAtIndex:(NSUInteger)index {
    return [self.qn_children objectAtIndex:index];
}

- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index {
    NSMutableArray *newChildren = [self p_newChildren];
    [newChildren insertObject:layout atIndex:index];
    [self p_updateChlidren:[newChildren copy]];
}

- (QNLayout *)qn_makeLayout:(void (^)(QNLayout *))layout {
    if (layout) {
        layout(self.qn_layout);
    }
    return self.qn_layout;
}

- (void)p_removeAllChildren {
    [self p_updateChlidren:nil];
}

- (void)qn_markDirty {
    for (id<QNLayoutProtocol> layoutElement in self.qn_children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [layoutElement qn_markDirty];
    }
    [self p_removeAllChildren];
}

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout {
    NSMutableArray *newChildren = [self p_newChildren];
    [newChildren removeObject:layout];
    [self p_updateChlidren:[newChildren copy]];
}

- (NSMutableArray *)p_newChildren {
    return self.qn_children ? [self.qn_children mutableCopy] : [NSMutableArray array];
}

@end
