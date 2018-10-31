//
//  QNFeedModel.m
//  QNYGKit
//
//  Created by jayhuan on 2018/9/26.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import "QNFeedModel.h"

@interface QNFeedModel()

//@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *imageName;

@end

@implementation QNFeedModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        self.title = dictionary[@"title"];
        self.content = dictionary[@"content"];
        self.username = dictionary[@"username"];
        self.time = dictionary[@"time"];
        self.imageName = dictionary[@"imageName"];
        self.ID = @"ID";
    }
    return self;
}

@end
