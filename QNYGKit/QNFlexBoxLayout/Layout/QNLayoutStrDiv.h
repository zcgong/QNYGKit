//
//  QNLayoutStrDiv.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/20.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNLayoutDiv.h"
#import "QNLayoutCalProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 动态计算字符串size的div，可以用来计算label的size
 */
@interface QNLayoutStrDiv : QNLayoutDiv<QNLayoutCalProtocol>
@property(nonatomic, copy, readonly) NSAttributedString *calAttributedStr;
+ (instancetype)divWithCalAttrStr:(NSAttributedString *)calAttrStr;
+ (instancetype)divWithCalAttrStr:(NSAttributedString *)calAttrStr lineNum:(NSUInteger)lineNum;
@end

NS_ASSUME_NONNULL_END
