//
//  QNFeedViewLayoutModel.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/27.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNFeedViewLayoutModel.h"
#import "QNFlexBoxLayout.h"
#import "QNFeedViewDataModel.h"

@interface QNFeedViewLayoutModel ()
@property(nonatomic, assign) CGRect titleFrame;
@property(nonatomic, assign) CGRect contentStrFrame;
@property(nonatomic, assign) CGRect contentImageFrame;
@property(nonatomic, assign) CGRect userStrFrame;
@property(nonatomic, assign) CGRect timeStrFrame;
@end

@implementation QNFeedViewLayoutModel

- (void)applyDataModel:(id<QNDataModelProtocol>)dataModel {
    QNFeedViewDataModel *fViewModel = (QNFeedViewDataModel *)dataModel;
    QNLayoutStrDiv *titleStrDiv = [QNLayoutStrDiv divWithCalAttrStr:fViewModel.titleAttr];
    QNLayoutStrDiv *contentStrDiv = [QNLayoutStrDiv divWithCalAttrStr:fViewModel.contentAttr];
    [contentStrDiv qn_makeLayout:^(QNLayout *layout) {
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    
    QNLayoutFixedSizeDiv *contentImageDiv = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 100)];
    
    QNLayoutDiv *div = [QNLayoutDiv linerLayoutDiv];
    
    QNLayoutStrDiv *userStrDiv = [QNLayoutStrDiv divWithCalAttrStr:fViewModel.nameAttr];
    QNLayoutStrDiv *timeStrDiv = [QNLayoutStrDiv divWithCalAttrStr:fViewModel.timeAttr];
    
    [div qn_makeLayout:^(QNLayout *layout) {
        layout.justifyContent.equalTo(@(QNJustifySpaceBetween));
        layout.children(@[userStrDiv, timeStrDiv]);
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalLayoutDiv];
    [mainDiv qn_makeLayout:^(QNLayout *layout) {
        layout.children(@[titleStrDiv, contentStrDiv, contentImageDiv, div]);
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    [mainDiv qn_layoutWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, QNUndefinedValue)];
    self.titleFrame = titleStrDiv.frame;
    self.contentStrFrame = contentStrDiv.frame;
    self.contentImageFrame = contentImageDiv.frame;
    self.userStrFrame = userStrDiv.frame;
    self.timeStrFrame = timeStrDiv.frame;
    self.frame = mainDiv.frame;
}

@end
