//
//  QNLayoutStrDiv.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/20.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNLayoutStrDiv.h"

@interface QNLayoutStrDiv ()
@property(nonatomic, copy) NSAttributedString *calAttributedStr;
@end

@implementation QNLayoutStrDiv

+ (instancetype)layoutStrDivWithCalAttrStr:(NSAttributedString *)calAttrStr {
    QNLayoutStrDiv *div = [self linerLayoutDiv];
    [div qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();
    }];
    div.calAttributedStr = calAttrStr;
    return div;
}

- (void)qn_layoutWithWrapContent {
    [self qn_layout].wrapContent();
    [super qn_layoutWithSize:QNUndefinedSize];
}

- (CGSize)calculateSizeWithSize:(CGSize)size {
    CGSize calSize = [self.calAttributedStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return CGSizeMake(ceil(calSize.width), ceil(calSize.height));
}

@end
