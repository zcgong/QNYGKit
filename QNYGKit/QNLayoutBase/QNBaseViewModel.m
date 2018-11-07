//
//  QNBaseViewModel.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/9/17.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNBaseViewModel.h"
#import "QNViewProtocol.h"

@implementation QNBaseViewModel

+ (QNViewModelItem *)getViewModelItemWithModel:(id<QNModelProtocol>)model {
    id<QNDataModelProtocol> dataModel = [[[self.class do_dataModelClass] alloc] initWithModel:model];
    id<QNLayoutModelProtocol> layoutModel = [[[self.class do_layoutModelClass] alloc] initWithDataModel:dataModel];
    QNViewModelItem *modelItem = [[QNViewModelItem alloc] init];
    modelItem.model = model;
    modelItem.dataModel = dataModel;
    modelItem.layoutModel = layoutModel;
    return modelItem;
}

+ (void)updateVideoModelItem:(QNViewModelItem *)videoModelItem {
    if (videoModelItem) {
        if (videoModelItem.dataModel.isInvalid) {
            id<QNDataModelProtocol> dataModel = [[[self.class do_dataModelClass] alloc] initWithModel:videoModelItem.model];
            videoModelItem.dataModel = dataModel;
        }
        if (videoModelItem.layoutModel.isInvalid) {
            id<QNLayoutModelProtocol> layoutModel = [[[self.class do_layoutModelClass] alloc] initWithDataModel:videoModelItem.dataModel];
            videoModelItem.layoutModel = layoutModel;
        }
    }
}

+ (Class)do_dataModelClass {
    return nil;
}

+ (Class)do_layoutModelClass {
    return nil;
}

@end
