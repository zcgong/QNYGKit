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

+ (instancetype)divWithAttributedString:(NSAttributedString *)calAttrStr {
    return [self divWithAttributedString:calAttrStr lineNum:0];
}

+ (instancetype)divWithAttributedString:(NSAttributedString *)calAttrStr lineNum:(NSUInteger)lineNum {
    QNLayoutStrDiv *div = [self linearLayout:^(QNLayout *layout) {
        layout.wrapContent();
    }];
    div.calAttributedStr = calAttrStr;
    div.lineNum = lineNum;
    return div;
}

#pragma mark - QNLayoutCalProtocol

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
