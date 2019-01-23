//
//  QNLayoutTextVirtualView.h
//  QQNews
//
//  Created by jayhuan on 2019/1/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "QNLayoutVirtualView.h"
#import "QNLayoutCalProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 需要动态计算文本尺寸的虚拟视图叶子节点，可代替UILabel等场景
 */
@interface QNLayoutTextVirtualView : QNLayoutVirtualView<QNLayoutCalProtocol>

@property(nonatomic, copy, readonly) NSAttributedString *calAttributedStr;
+ (instancetype)virtualViewWithAttributedString:(NSAttributedString *)attributedString;
+ (instancetype)virtualViewWithAttributedString:(NSAttributedString *)attributedString lineNum:(NSUInteger)lineNum;

@end

NS_ASSUME_NONNULL_END
