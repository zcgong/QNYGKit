//
//  QNBaseViewModel.m
//  FlexBoxLayout_Example
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 qiang.shen. All rights reserved.
//

#import "QNBaseViewModel.h"
#import "QNViewProtocol.h"

@implementation QNBaseViewModel

+ (QNViewModelItem *)getViewModelItemWithModel:(id<QNModelProtocol>)model {
    id<QNDataModelProtocol> dataModel = [[[self.class do_dataModelClass] alloc] initWithModel:model];
    QNLayoutCache *cache = [self cacheWithDataModel:dataModel];
    QNViewModelItem *modelItem = [[QNViewModelItem alloc] init];
    modelItem.model = model;
    modelItem.dataModel = dataModel;
    modelItem.layoutCache = cache;
    return modelItem;
}

+ (NSArray<QNViewModelItem *> *)getViewModelItemsWithModels:(NSArray<id<QNModelProtocol>> *)models {
    NSMutableArray *result = [NSMutableArray array];
    for (id<QNModelProtocol> model in models) {
        id<QNDataModelProtocol> dataModel = [[[self do_dataModelClass] alloc] initWithModel:model];
        QNLayoutCache *cache = [self.class cacheWithDataModel:dataModel];
        QNViewModelItem *modelItem = [[QNViewModelItem alloc] init];
        modelItem.model = model;
        modelItem.dataModel = dataModel;
        modelItem.layoutCache = cache;
        [result addObject:modelItem];
    }
    return [result copy];
}

+ (Class)do_dataModelClass {
    return nil;
}

+ (Class)do_viewClass {
    return nil;
}

+ (QNYGViewLayoutType)do_viewLayoutType {
    return kQNYGViewLayoutTypeWrap;
}

+ (QNLayoutCache *)cacheWithDataModel:(id<QNDataModelProtocol>)dataModel {
    UIView<QNViewProtocol> *cView = [[self do_viewClass] defaultView];
    [cView applyDataModel:dataModel];
    
    [cView qn_applyLayoutWithLayoutType:[self do_viewLayoutType]];
    QNLayoutCache *cache = [cView.qn_layout layoutCache];
    return cache;
}

@end
