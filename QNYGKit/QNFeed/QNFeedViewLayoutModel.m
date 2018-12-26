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
    QNLayoutStrDiv *titleStrDiv = [QNLayoutStrDiv divWithAttributedString:fViewModel.titleAttr];
    QNLayoutStrDiv *contentStrDiv = [QNLayoutStrDiv divWithAttributedString:fViewModel.contentAttr];
    [contentStrDiv qn_makeLayout:^(QNLayout *layout) {
        layout.margin.eq_insets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    
    QNLayoutFixedSizeDiv *contentImageDiv = [QNLayoutFixedSizeDiv divWithFixedSize:CGSizeMake(100, 100)];
    
    QNLayoutStrDiv *userStrDiv = [QNLayoutStrDiv divWithAttributedString:fViewModel.nameAttr];
    QNLayoutStrDiv *timeStrDiv = [QNLayoutStrDiv divWithAttributedString:fViewModel.timeAttr];
    
    QNLayoutDiv *div = [QNLayoutDiv linearDivWithLayout:^(QNLayout *layout) {
        layout.spaceBetween();
        layout.children(@[userStrDiv, timeStrDiv]);
        layout.marginT.eq(5);
    }];
    QNLayoutDiv *mainDiv = [QNLayoutDiv verticalDivWithLayout:^(QNLayout *layout) {
        layout.children(@[titleStrDiv, contentStrDiv, contentImageDiv, div]);
        layout.padding.eq_insets(UIEdgeInsetsMake(5, 5, 5, 5));
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
