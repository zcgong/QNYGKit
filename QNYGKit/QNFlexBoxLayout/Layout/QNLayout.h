//
//  QNLayout.h
//  QNYGKit
//
//  Created by jayhuan on 2018/9/21.
//  Copyright © 2018 jayhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const CGSize QNUndefinedSize;

extern const CGFloat QNUndefinedValue;

typedef enum QNFlexDirection {
    QNFlexDirectionColumn,
    QNFlexDirectionColumnReverse,
    QNFlexDirectionRow,
    QNFlexDirectionRowReverse,
} QNFlexDirection;

typedef enum QNMeasureMode {
    QNMeasureModeUndefined,
    QNMeasureModeExactly,
    QNMeasureModeAtMost,
} QNMeasureMode;

typedef enum QNPrintOptions {
    QNPrintOptionsLayout = 1,
    QNPrintOptionsStyle = 2,
    QNPrintOptionsChildren = 4,
} QNPrintOptions;

typedef enum QNEdge {
    QNEdgeLeft,
    QNEdgeTop,
    QNEdgeRight,
    QNEdgeBottom,
    QNEdgeStart,
    QNEdgeEnd,
    QNEdgeHorizontal,
    QNEdgeVertical,
    QNEdgeAll,
} QNEdge;

typedef enum QNPositionType {
    QNPositionTypeRelative,
    QNPositionTypeAbsolute,
} QNPositionType;

typedef enum QNDimension {
    QNDimensionWidth,
    QNDimensionHeight,
} QNDimension;

typedef enum QNJustify {
    QNJustifyFlexStart,
    QNJustifyCenter,
    QNJustifyFlexEnd,
    QNJustifySpaceBetween,
    QNJustifySpaceAround,
} QNJustify;

typedef enum QNDirection {
    QNDirectionInherit,
    QNDirectionLTR,
    QNDirectionRTL,
} QNDirection;

typedef enum QNLogLevel {
    QNLogLevelError,
    QNLogLevelWarn,
    QNLogLevelInfo,
    QNLogLevelDebug,
    QNLogLevelVerbose,
} QNLogLevel;

typedef enum QNWrap {
    QNWrapNoWrap,
    QNWrapWrap,
    QNWrapCount,
} QNWrap;


typedef enum QNAlign {
    QNAlignAuto,
    QNAlignFlexStart,
    QNAlignCenter,
    QNAlignFlexEnd,
    QNAlignStretch,
} QNAlign;

NS_ASSUME_NONNULL_BEGIN

@class QNLayoutCache;
@interface QNLayout : NSObject

- (QNLayout *)flexDirection;

- (QNLayout *)justifyContent;

- (QNLayout *)alignContent;

- (QNLayout *)alignItems;

- (QNLayout *)alignSelf;

- (QNLayout *)positionType;

- (QNLayout *)flexWrap;

- (QNLayout *)flexGrow;

- (QNLayout *)flexShrink;

- (QNLayout *)flexBasiss;

- (QNLayout *)position;

- (QNLayout *)margin;

- (QNLayout *)padding;

- (QNLayout *)width;

- (QNLayout *)height;

- (QNLayout *)minWidth;

- (QNLayout *)minHeight;

- (QNLayout *)maxWidth;

- (QNLayout *)maxHeight;

- (QNLayout *)size;

- (QNLayout *)maxSize;

- (QNLayout *)minSize;

- (QNLayout *)aspectRatio;

- (QNLayout * (^)(id attr))equalTo;

- (QNLayout * (^)(CGSize attr))equalToSize;

- (QNLayout * (^)(UIEdgeInsets attr))equalToEdgeInsets;

/**
 必须是叶子结点并且继承自协议QNLayoutCalProtocolc设置才生效
 */
- (QNLayout * (^)(void))wrapContent;

- (QNLayout * (^)(void))wrapSize;

- (QNLayout * (^)(NSArray*))children;

- (void)applyLayoutCache:(QNLayoutCache *)layoutCache;

- (QNLayoutCache *)layoutCache;;

@end
NS_ASSUME_NONNULL_END
