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

/**
 添加一个布局子元素
 */
- (void)qn_addChild:(id<QNLayoutProtocol>)layout;

/**
 添加多个布局子元素
 */
- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children;

/**
 插入一个布局子元素
 
 @param layout
 @param index 位置
 */
- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index;

/**
 获取某个位置的子元素
 
 @param index 位置
 */
- (id<QNLayoutProtocol>)qn_childLayoutAtIndex:(NSUInteger)index;

/**
 删除某个子元素
 */
- (void)qn_removeChild:(id<QNLayoutProtocol>)layout;

/**
 子元素数量
 */
- (NSUInteger)qn_childrenCount;

/**
 递归设置布局
 */
- (void)qn_applyLayoutToViewHierachy;

/**
 根据给定的尺寸进行布局
 */
- (void)qn_layoutWithSize:(CGSize)size;

/**
 根据给定的尺寸进行异步布局
 */
- (void)qn_asyncLayoutWithSize:(CGSize)size;

/**
 自适应大小
 */
- (void)qn_layoutWithWrapContent;

/**
 设置布局信息：margin、padding、方向、size大小、size计算方式，居中等
 */
- (QNLayout *)qn_makeLayout:(void(^)(QNLayout *layout))layout;

/**
 标记布局缓存失效
 */
- (void)qn_markDirty;

@end
