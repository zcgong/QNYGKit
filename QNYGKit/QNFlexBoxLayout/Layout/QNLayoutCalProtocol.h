//
//  QNLayoutCalProtocol.h
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/20.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNLayoutCalProtocol <NSObject>
- (CGSize)calculateSizeWithSize:(CGSize)size;
- (void)qn_layoutWithWrapContent;
@end

NS_ASSUME_NONNULL_END
