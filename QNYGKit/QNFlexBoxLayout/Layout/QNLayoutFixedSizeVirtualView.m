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

@end
