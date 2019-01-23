//
//  QNLayoutFixedSizeVirtualView.m
//  QQNews
//
//  Created by jayhuan on 2019/1/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QNLayoutFixedSizeVirtualView.h"

@interface QNLayoutFixedSizeVirtualView ()
@property(nonatomic, assign) CGSize fixedSize;
@end

@implementation QNLayoutFixedSizeVirtualView

+ (instancetype)virtualViewWithFixedSize:(CGSize)fixedSize {
    QNLayoutFixedSizeVirtualView *vv = [self linearLayout:^(QNLayout *layout) {
        layout.size(fixedSize);
    }];
    vv.fixedSize = fixedSize;
    return vv;
}

- (void)qn_layoutWithSize:(CGSize)size {
    [super qn_layoutWithSize:self.fixedSize];
}

- (void)qn_asyncLayoutWithSize:(CGSize)size complete:(void (^)(CGRect frame))complete {
    [super qn_asyncLayoutWithSize:self.fixedSize complete:complete];
}

- (void)qn_layoutWithWrapContent {
    [super qn_layoutWithSize:self.fixedSize];
}

- (void)qn_addChild:(id<QNLayoutProtocol>)layout {
    NSAssert(NO, @"QNLayoutFixedSizeVirtualView can be only used to be leaf node.");
}

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children {
    NSAssert(NO, @"QNLayoutFixedSizeVirtualView can be only used to be leaf node.");
}

- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index {
    NSAssert(NO, @"QNLayoutFixedSizeVirtualView can be only used to be leaf node.");
}

@end
