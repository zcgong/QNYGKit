//
//  QNFeedViewDataModel.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNFeedViewDataModel.h"
#import "QNFeedModel.h"

@implementation QNFeedViewDataModel

- (void)applyModel:(QNFeedModel *)model {
    self.titleAttr = [[NSAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    self.contentAttr = [[NSAttributedString alloc] initWithString:model.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    self.contentImage = [UIImage imageNamed:model.imageName];
    
    self.nameAttr = [[NSAttributedString alloc] initWithString:model.username attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    self.timeAttr = [[NSAttributedString alloc] initWithString:model.time attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
}

@end
