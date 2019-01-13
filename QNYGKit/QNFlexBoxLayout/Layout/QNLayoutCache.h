//
//  QNLayoutCache.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QNLayoutCache : NSObject

/// 自身frame
@property(nonatomic, assign) CGRect frame;

/// 子元素frame
@property(nonatomic, copy) NSArray<QNLayoutCache *> *subLayoutCaches;

@end
