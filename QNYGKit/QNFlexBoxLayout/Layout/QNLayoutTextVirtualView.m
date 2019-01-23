//
//  QNLayoutTextVirtualView.m
//  QQNews
//
//  Created by jayhuan on 2019/1/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QNLayoutTextVirtualView.h"

@interface QNLayoutTextVirtualView ()
@property(nonatomic, copy) NSAttributedString *calAttributedStr;
@property(nonatomic, assign) NSUInteger lineNum;
@end

@implementation QNLayoutTextVirtualView

+ (instancetype)virtualViewWithAttributedString:(NSAttributedString *)attributedString {
    return [self virtualViewWithAttributedString:attributedString lineNum:0];
}

+ (instancetype)virtualViewWithAttributedString:(NSAttributedString *)attributedString lineNum:(NSUInteger)lineNum {
    QNLayoutTextVirtualView *vv = [self linearLayout:^(QNLayout *layout) {
        layout.wrapContent();
    }];
    vv.calAttributedStr = attributedString;
    vv.lineNum = lineNum;
    return vv;
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

#pragma mark - QNLayoutCalProtocol

- (CGSize)calculateSizeWithSize:(CGSize)size {
    CGSize calSize = CGSizeZero;
    if (self.lineNum == 0) {
        calSize = [self.calAttributedStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    } else {
        // 暂时没有找到合适的方法，在不创建label的情况下计算高度，coretext可以，但是计算有误差，待优化。
        UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        calLabel.numberOfLines = self.lineNum;
        calLabel.attributedText = self.calAttributedStr;
        calSize = [calLabel sizeThatFits:size];
    }
    
    return CGSizeMake(ceil(calSize.width), ceil(calSize.height));
}

- (BOOL)allowAsyncCalculated {
    // 使用UILabel计算size的时候不能异步操作
    return (self.lineNum <= 0);
}

@end
