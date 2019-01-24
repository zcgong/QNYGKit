//
//  QNFeedUtil.m
//  QNYGKit
//
//  Created by Zhengjie Huan on 2019/1/24.
//  Copyright © 2019 jayhuan. All rights reserved.
//

#import "QNFeedUtil.h"
#import "QNFeedModel.h"

@implementation QNFeedUtil

+ (QNFeedModel *)fetchFirstFeedModel {
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *feedDicts = rootDict[@"feed"];
    
    NSMutableArray *feeds = @[].mutableCopy;
    
    [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [feeds addObject:[[QNFeedModel alloc] initWithDictionary:obj]];
    }];
    
    QNFeedModel *feedModel = [feeds objectAtIndex:0];
    return feedModel;
}

@end
