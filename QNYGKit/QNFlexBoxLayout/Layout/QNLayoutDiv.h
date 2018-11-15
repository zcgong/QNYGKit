//
//  QNLayoutDiv.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNLayoutProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNLayoutDiv : NSObject<QNLayoutProtocol>

@property(nonatomic, assign) CGRect frame;
@property(nonatomic, strong, readonly) QNLayout *qn_layout;

/**
 水平布局的div
 */
+ (instancetype)linerLayoutDiv;

/**
 垂直方向的Div
 */
+ (instancetype)verticalLayoutDiv;

+ (instancetype)layoutDivWithFlexDirection:(QNFlexDirection)direction;

+ (instancetype)layoutDivWithFlexDirection:(QNFlexDirection)direction
                            justifyContent:(QNJustify)justifyContent
                                alignItems:(QNAlign)alignItems
                                  children:(NSArray<id<QNLayoutProtocol>>*)children;

@end

NS_ASSUME_NONNULL_END
