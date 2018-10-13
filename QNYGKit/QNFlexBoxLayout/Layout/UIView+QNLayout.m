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

extern void YGSetMesure(QNLayout *layout);

@implementation UIView (QNLayout)

- (void)setQnStyles:(NSDictionary *)qnStyles {
    [self qn_layout].qnStyles = qnStyles;
}

- (NSDictionary *)qnStyles {
    return [self qn_layout].qnStyles;
}

- (void)setQn_children:(NSArray<id<QNLayoutProtocol>> *)children {
    if ([self qn_children] == children) {
        return;
    }
    objc_setAssociatedObject(self, @selector(qn_children), children, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[self qn_layout] removeAllChildren];
    
    for (id<QNLayoutProtocol> child in children) {
        if ([child isKindOfClass:[UIView class]]) {
            [(UIView *)child qn_markAllowLayout];
        }
    }
    
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [[self qn_layout] addChild:layoutElement.qn_layout];
    }
}

- (NSArray *)qn_children {
    return objc_getAssociatedObject(self, _cmd) ?:[NSMutableArray array];
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren addObject:layout];
    self.qn_children = newChildren;
}

- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index {
    NSAssert([layout conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren insertObject:layout atIndex:index];
    self.qn_children = newChildren;
}

- (id<QNLayoutProtocol>)qn_childLayoutAtIndex:(NSUInteger)index {
    return [[self qn_children] objectAtIndex:index];
}

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout {
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren removeObject:layout];
    self.qn_children = newChildren;
}

- (void)qn_removeAllChildren {
    self.qn_children = nil;
}

- (void)qn_markDirty {
    NSArray *children = [self qn_children];
    for (id<QNLayoutProtocol> layoutElement in children) {
        NSAssert([layoutElement conformsToProtocol:@protocol(QNLayoutProtocol)], @"invalid");
        [layoutElement qn_markDirty];
    }
    self.qn_children = nil;
    objc_setAssociatedObject(self, @selector(qn_layout), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)qn_applyLayoutWithLayoutType:(QNYGViewLayoutType)layoutType {
    switch (layoutType) {
        case kQNYGViewLayoutTypeWrap:
            [self qn_wrapContent];
            break;
        case kQNYGViewLayoutTypeWidth:
            [self qn_applyLayoutWithFixedWidth];
            break;
        case kQNYGViewLayoutTypeHeight:
            [self qn_applyLayoutWithFixedHeight];
            break;
        case kQNYGViewLayoutTypeSize:
            [self qn_applyLayoutWithFixedSize];
            break;
        default:
            break;
    }
}

- (void)qn_wrapContent {
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:qn_undefinedSize];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_applyLayoutWithFixedWidth {
    [self qn_layout].width.equalTo(@(self.frame.size.width));
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:CGSizeMake(self.frame.size.width, qn_undefined)];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_applyLayoutWithFixedHeight {
    [self qn_layout].height.equalTo(@(self.frame.size.height));
    [self qn_layout].wrapContent();
    [[self qn_layout] calculateLayoutWithSize:CGSizeMake(qn_undefined, self.frame.size.height)];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}

- (void)qn_applyLayoutWithFixedSize {
    [self qn_applyLayouWithSize:self.frame.size];
}

- (void)qn_setFlexDirection:(QNFlexDirection)direction
             justifyContent:(QNJustify)justifyContent
                 alignItems:(QNAlign)alignItems
                   children:(NSArray<id<QNLayoutProtocol>>*)children {
    [self qn_makeLayout:^(QNLayout *layout) {
        [layout setFlexDirection:direction];
        [layout setJustifyContent:justifyContent];
        [layout setAlignItems:alignItems];
    }];
    [self setQn_children:children];
}

- (QNLayout *)qn_layout {
    QNLayout *layout = objc_getAssociatedObject(self, _cmd);
    if (!layout) {
        layout = [QNLayout new];
        layout.context = self;
        objc_setAssociatedObject(self, _cmd, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return layout;
}

#pragma mark - layout

- (void)qn_applyLayouWithSize:(CGSize)size {
    [[self qn_layout] calculateLayoutWithSize:size];
    self.frame = [self qn_layout].frame;
    [self qn_applyLayoutToViewHierachy];
}


- (void)qn_asycApplyLayoutWithSize:(CGSize)size {
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[self qn_layout] calculateLayoutWithSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frame = [self qn_layout].frame;
            [self qn_applyLayoutToViewHierachy];
        });
    });
}


- (void)qn_applyLayoutToViewHierachy {
    for (id<QNLayoutProtocol> layoutElement in [self qn_children]) {
        layoutElement.frame = layoutElement.qn_layout.frame;
        [layoutElement qn_applyLayoutToViewHierachy];
    }
}

- (void)qn_markAllowLayout {
    [self qn_layout];
}

- (QNLayout *)qn_makeLayout:(void(^)(QNLayout *layout))layout {
    if (layout) {
        layout([self qn_layout]);
    }
    return [self qn_layout];
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSMutableArray *newChildren = [[self qn_children] mutableCopy];
    [newChildren addObjectsFromArray:children];
    self.qn_children = newChildren;
}


@end
