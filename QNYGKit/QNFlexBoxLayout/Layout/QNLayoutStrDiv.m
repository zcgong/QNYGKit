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
@property(nonatomic, assign) NSUInteger lineNum;
@end

@implementation QNLayoutStrDiv

+ (instancetype)layoutStrDivWithCalAttrStr:(NSAttributedString *)calAttrStr {
    return [self layoutStrDivWithCalAttrStr:calAttrStr lineNum:0];
}

+ (instancetype)layoutStrDivWithCalAttrStr:(NSAttributedString *)calAttrStr lineNum:(NSUInteger)lineNum {
    QNLayoutStrDiv *div = [self linerLayoutDiv];
    [div qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();
    }];
    div.calAttributedStr = calAttrStr;
    div.lineNum = lineNum;
    return div;
}

- (void)qn_layoutWithWrapContent {
    [self qn_layout].wrapContent();
    [super qn_layoutWithSize:QNUndefinedSize];
}

- (CGSize)calculateSizeWithSize:(CGSize)size {
    CGSize calSize = CGSizeZero;
    if (self.lineNum == 0) {
        calSize = [self.calAttributedStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    } else {
        UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        calLabel.numberOfLines = self.lineNum;
        calLabel.attributedText = self.calAttributedStr;
        calSize = [calLabel sizeThatFits:size];
    }
    
    return CGSizeMake(ceil(calSize.width), ceil(calSize.height));
}

@end
