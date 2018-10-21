//
//  QNFeedView.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNFeedView.h"
#import "QNFlexBoxLayout.h"

@interface QNFeedView ()

@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *contentLabel;
@property (nonatomic, strong)  UIImageView *contentImageView;
@property (nonatomic, strong)  UILabel *usernameLabel;
@property (nonatomic, strong)  UILabel *timeLabel;

@end

@implementation QNFeedView

+ (instancetype)defaultFeedView {
    QNFeedView *feedView = [[QNFeedView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    return feedView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_createViews];
        [self p_layoutViews];
    }
    return self;
}

+ (Class)do_viewModelClass {
    return [QNFeedViewModel class];
}

- (void)p_createViews {
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 2;
    _titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_titleLabel];
    _titleLabel.backgroundColor = [UIColor greenColor];
    
    _contentLabel = [UILabel new];
    [self addSubview:_contentLabel];
    _contentLabel.backgroundColor = [UIColor redColor];
    _contentLabel.numberOfLines = 0;
    
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_contentImageView];
    _contentImageView.backgroundColor = [UIColor purpleColor];
    
    _usernameLabel = [UILabel new];
    _usernameLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_usernameLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.backgroundColor = [UIColor lightTextColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
}

- (void)applyDataModel:(QNFeedViewDataModel *)dataModel {
    _titleLabel.attributedText = dataModel.titleAttr;
    _contentLabel.attributedText = dataModel.contentAttr;
    _contentImageView.image = dataModel.contentImage;
    _usernameLabel.attributedText = dataModel.nameAttr;
    _timeLabel.attributedText = dataModel.timeAttr;
    [self qn_markDirty];
    [self p_layoutViews];
    [self qn_layoutWithFixedWidth];
}

- (void)p_layoutViews {
    [_titleLabel qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();
    }];
    
    [_contentLabel qn_makeLayout:^(QNLayout *layout) {
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 0, 10, 0)).wrapContent();
    }];
    
    [_contentImageView qn_makeLayout:^(QNLayout *layout) {
//        layout.width.height.equalTo(@(100));
        layout.wrapSize();
    }];
    
    
    QNLayoutDiv *div = [QNLayoutDiv layoutDivWithFlexDirection:QNFlexDirectionRow];
    
    [_usernameLabel qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();
    }];
    
    [_timeLabel qn_makeLayout:^(QNLayout *layout) {
        layout.wrapContent();
    }];
    
    [div qn_makeLayout:^(QNLayout *layout) {
//        layout.flexDirection.equalTo(@(QNFlexDirectionRow));
        layout.justifyContent.equalTo(@(QNJustifySpaceBetween));
        layout.children(@[self.usernameLabel, self.timeLabel]);
        layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    [self qn_makeLayout:^(QNLayout *layout) {
        layout.flexDirection.equalTo(@(QNFlexDirectionColumn));
        layout.children(@[self.titleLabel, self.contentLabel, self.contentImageView, div]);
        layout.padding.equalToEdgeInsets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

@end
