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

@property(nonatomic, copy) NSDictionary *qnStyles;

- (void)qn_addChild:(id<QNLayoutProtocol>)layout;

- (void)qn_addChildren:(NSArray<id<QNLayoutProtocol>> *)children;

- (void)qn_insertChild:(id<QNLayoutProtocol>)layout atIndex:(NSInteger)index;

- (id<QNLayoutProtocol>)qn_childLayoutAtIndex:(NSUInteger)index;

- (void)qn_removeChild:(id<QNLayoutProtocol>)layout;

- (void)qn_removeAllChildren;

- (void)qn_applyLayoutToViewHierachy;

- (void)qn_applyLayouWithSize:(CGSize)size;

- (void)qn_asycApplyLayoutWithSize:(CGSize)size;

- (QNLayout *)qn_makeLayout:(void(^)(QNLayout *layout))layout;

- (void)qn_markDirty;

@end
