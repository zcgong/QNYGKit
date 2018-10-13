//
//  QNFeedViewModel.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNFeedViewModel.h"
#import "QNFeedView.h"
#import "QNFeedViewDataModel.h"

@implementation QNFeedViewModel

+ (Class)do_dataModelClass {
    return [QNFeedViewDataModel class];
}

+ (Class)do_viewClass {
    return [QNFeedView class];
}

+ (QNYGViewLayoutType)do_viewLayoutType {
    return kQNYGViewLayoutTypeWidth;
}

@end
