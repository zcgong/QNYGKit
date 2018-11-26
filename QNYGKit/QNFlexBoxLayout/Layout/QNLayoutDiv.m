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
@property(nonatomic, strong) NSMutableArray *mChildren;
@property(nonatomic, strong) QNLayout *qn_layout;

@end

@implementation QNLayoutDiv

- (instancetype)init {
    if (self = [super init]) {
        self.mChildren = [NSMutableArray array];
        self.qn_layout = [QNLayout new];
        self.qn_layout.context = self;
    }
    return self;
}

- (void)setQn_children:(NSArray<id<QNLayoutProtocol>> *)children {
    if (self.mChildren == children) {
        return;
    }
    self.mChildren = [children copy];
    [self.qn_layout removeAllChildren];
    
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [self.qn_layout addChild:layoutElement.qn_layout];
    }
}

- (NSArray *)qn_children {
    return [self.mChildren copy];
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [self.mChildren mutableCopy];
    [newChildren addObject:layout];
    self.qn_children = newChildren;
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSMutableArray *newChildren = [self.qn_children mutableCopy];
    [newChildren addObjectsFromArray:children];
    self.qn_children = newChildren;
}

- (void)qn_layoutWithSize:(CGSize)size {
    [self.qn_layout calculateLayoutWithSize:size];
    self.frame = self.qn_layout.frame;
    [self qn_applyLayoutToViewHierachy];
}


- (void)qn_applyLayoutToViewHierachy {
    for (id<QNLayoutProtocol> layoutElement in self.mChildren) {
        
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
        
        [layoutElement qn_applyLayoutToViewHierachy];
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
    [self.mChildren insertObject:layout atIndex:index];
    self.qn_children = self.mChildren;
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
    [self.mChildren removeObject:layout];
    self.qn_children = [self.mChildren copy];
}

+ (instancetype)linerLayoutDiv {
    return [self layoutDivWithFlexDirection:QNFlexDirectionRow];
}

+ (instancetype)verticalLayoutDiv {
    return [self layoutDivWithFlexDirection:QNFlexDirectionColumn];
}

+ (instancetype)layoutDivWithFlexDirection:(QNFlexDirection)direction {
    QNLayoutDiv *layoutDiv = [self new];
    [layoutDiv qn_makeLayout:^(QNLayout *layout) {
        [layout setFlexDirection:direction];
    }];
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

@end
