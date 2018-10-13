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

@property(nonatomic, assign) CGRect frame;
@property(nonatomic, copy) NSArray<QNLayoutCache *> *subLayoutCaches;

@end
