//
//  QNLayoutProtocol.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNLayout.h"
#import "Yoga.h"

@protocol QNLayoutProtocol <NSObject>

@required

@property(nonatomic, strong, readonly) QNLayout *qn_layout;
@property(nonatomic, assign) CGRect frame;
@property(nonatomic, copy) NSArray<id<QNLayoutProtocol>> *qn_children;


- (void)qn_addChild:(id<QNLayoutProtocol>)layout;

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children;

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout;

- (void)qn_applyLayoutToViewHierachy;

/**
 根据给定的尺寸进行布局
 */
- (void)qn_layoutWithSize:(CGSize)size;

/**
 根据给定的尺寸进行异步布局
 */
- (void)qn_asyncLayoutWithSize:(CGSize)size;

- (QNLayout *)qn_makeLayout:(void(^)(QNLayout *layout))layout;

/**
 标记布局缓存失效
 */
- (void)qn_markDirty;

@end
