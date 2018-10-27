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
#import "QNFeedViewLayoutModel.h"

@implementation QNFeedViewModel

+ (Class)do_dataModelClass {
    return [QNFeedViewDataModel class];
}

+ (Class)do_layoutModelClass {
    return [QNFeedViewLayoutModel class];
}

@end
