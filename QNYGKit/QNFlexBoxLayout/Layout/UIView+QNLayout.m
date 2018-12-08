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

typedef NS_ENUM(NSInteger, QNYGViewLayoutType) {
    kQNYGViewLayoutTypeWrap,
    kQNYGViewLayoutTypeWidth,
    kQNYGViewLayoutTypeHeight,
    kQNYGViewLayoutTypeSize
};

extern void YGSetMesure(QNLayout *layout);

@implementation UIView (QNLayout)

- (QNLayout *)qn_makeLinearLayout:(void(^)(QNLayout *layout))layout {
    QNLayout *linearLayout = [self qn_makeLayout:layout];
    linearLayout.flexDirection.equalTo(@(QNFlexDirectionRow));
    return linearLayout;
}
- (QNLayout *)qn_makeVerticalLayout:(void(^)(QNLayout *layout))layout {
    QNLayout *linearLayout = [self qn_makeLayout:layout];
    linearLayout.flexDirection.equalTo(@(QNFlexDirectionColumn));
    return linearLayout;
}

- (void)setQn_children:(NSArray<id<QNLayoutProtocol>> *)children {
    if ([self qn_children] == children) {
        return;
    }
    objc_setAssociatedObject(self, @selector(qn_children), children, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[self qn_layout] removeAllChildren];
    
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [[self qn_layout] addChild:layoutElement.qn_layout];
    }
}

- (NSArray *)qn_children {
    return objc_getAssociatedObject(self, _cmd) ?: @[];
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren addObject:layout];
    self.qn_children = newChildren;
}

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout {
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren removeObject:layout];
    self.qn_children = newChildren;
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

- (void)qn_layoutWithLayoutType:(QNYGViewLayoutType)layoutType {
    switch (layoutType) {
        case kQNYGViewLayoutTypeWrap:
            [self qn_layoutWithWrapContent];
            break;
        case kQNYGViewLayoutTypeWidth:
            [self qn_layoutWithFixedWidth];
            break;
        case kQNYGViewLayoutTypeHeight:
            [self qn_layoutWithFixedHeight];
            break;
        case kQNYGViewLayoutTypeSize:
            [self qn_layoutWithFixedSize];
            break;
        default:
            break;
    }
}

- (void)qn_layoutWithWrapContent {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:QNUndefinedSize];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_layoutOriginWithWrapContent {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:QNUndefinedSize];
    [self qn_layoutSize:[self qn_layout].frame.size];
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_layoutWithFixedWidth {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:CGSizeMake(self.frame.size.width, QNUndefinedValue)];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_layoutWithFixedHeight {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:CGSizeMake(QNUndefinedValue, self.frame.size.height)];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_layoutWithFixedSize {
    [self qn_layoutWithSize:self.frame.size];
}

- (void)qn_layoutOriginWithLayoutType:(QNYGViewLayoutType)layoutType {
    switch (layoutType) {
        case kQNYGViewLayoutTypeWrap:
            [self qn_layoutOriginWithWrapContent];
            break;
        case kQNYGViewLayoutTypeWidth:
            [self qn_layoutOriginWithFixedWidth];
            break;
        case kQNYGViewLayoutTypeHeight:
            [self qn_layoutOriginWithFixedHeight];
            break;
        case kQNYGViewLayoutTypeSize:
            [self qn_layoutOriginWithFixedSize];
            break;
        default:
            break;
    }
}

- (void)qn_layoutOriginWithFixedWidth {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:CGSizeMake(self.frame.size.width, QNUndefinedValue)];
    [self qn_layoutSize:[self qn_layout].frame.size];
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_layoutOriginWithFixedHeight {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:CGSizeMake(QNUndefinedValue, self.frame.size.height)];
    [self qn_layoutSize:[self qn_layout].frame.size];
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_layoutOriginWithFixedSize {
    [self qn_layoutOriginWithSize:self.frame.size];
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

- (void)qn_layoutWithSize:(CGSize)size {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:size];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_asyncLayoutWithSize:(CGSize)size {
    [QNAsyncLayoutTransaction addCalculateBlock:^{
        [self qn_layout].wrapContent();
        [self.qn_layout calculateLayoutWithSize:size];
    } complete:^{
        self.frame = self.qn_layout.frame;
        [self qn_applyLayoutToViewHierachy];
    }];
}

- (void)qn_layoutOriginWithSize:(CGSize)size {
    [[self qn_layout] calculateLayoutWithSize:size];
    [self qn_layoutSize:[self qn_layout].frame.size];
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_asyncLayoutOriginWithSize:(CGSize)size {
    [QNAsyncLayoutTransaction addCalculateBlock:^{
        [self.qn_layout calculateLayoutWithSize:size];
    } complete:^{
        [self qn_layoutSize:[self qn_layout].frame.size];
        [self qn_applyLayoutToViewHierachy];
    }];
}

- (void)qn_applyLayoutToViewHierachy {
    for (id<QNLayoutProtocol> layoutElement in [self qn_children]) {
        layoutElement.frame = layoutElement.qn_layout.frame;
        [layoutElement qn_applyLayoutToViewHierachy];
    }
}

- (QNLayout *)qn_makeLayout:(void(^)(QNLayout *layout))layout {
    if (layout) {
        QNLayout *mLayout = objc_getAssociatedObject(self, @selector(qn_layout));
        if (mLayout) {
            [self p_removeAllChildren];
            objc_setAssociatedObject(self, @selector(qn_layout), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        layout([self qn_layout]);
    }
    return [self qn_layout];
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren addObjectsFromArray:children];
    self.qn_children = newChildren;
}

- (CGSize)calculateSizeWithSize:(CGSize)size {
    CGSize calSize = [self sizeThatFits:size];
    return CGSizeMake(ceil(calSize.width), ceil(calSize.height));
}

- (void)qn_layoutSize:(CGSize)size {
    CGRect newframe = self.frame;
    newframe.size = size;
    self.frame = newframe;
}

@end
