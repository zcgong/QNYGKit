//
//  QNFeedViewLayoutModel.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2018/10/27.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNFeedViewLayoutModel.h"
#import "QNYGKit.h"
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
    QNLayoutTextVirtualView *titleVirtualView = [QNLayoutTextVirtualView virtualViewWithAttributedString:fViewModel.titleAttr];
    QNLayoutTextVirtualView *contentVirtualView = [QNLayoutTextVirtualView virtualViewWithAttributedString:fViewModel.contentAttr];
    [contentVirtualView qn_makeLayout:^(QNLayout *layout) {
        layout.margin(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    
    QNLayoutFixedSizeVirtualView *contentImageVirtualView = [QNLayoutFixedSizeVirtualView virtualViewWithFixedSize:CGSizeMake(100, 100)];
    
    QNLayoutTextVirtualView *userTextVirtualView = [QNLayoutTextVirtualView virtualViewWithAttributedString:fViewModel.nameAttr];
    QNLayoutTextVirtualView *timeTextVirtualView = [QNLayoutTextVirtualView virtualViewWithAttributedString:fViewModel.timeAttr];
    
    QNLayoutVirtualView *virtualView = [QNLayoutVirtualView linearLayout:^(QNLayout *layout) {
        layout.spaceBetween();
        layout.children(@[userTextVirtualView, timeTextVirtualView]);
        layout.marginT(5);
    }];
    QNLayoutVirtualView *mainvirtualView = [QNLayoutVirtualView verticalLayout:^(QNLayout *layout) {
        layout.children(@[titleVirtualView, contentVirtualView, contentImageVirtualView, virtualView]);
        layout.padding(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    [mainvirtualView qn_layoutWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, QNUndefinedValue)];
    self.titleFrame = titleVirtualView.frame;
    self.contentStrFrame = contentVirtualView.frame;
    self.contentImageFrame = contentImageVirtualView.frame;
    self.userStrFrame = userTextVirtualView.frame;
    self.timeStrFrame = timeTextVirtualView.frame;
    self.frame = mainvirtualView.frame;
}

@end
