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
    QNFlexDirectionColumn,          // 垂直布局
    QNFlexDirectionColumnReverse,   // 垂直反向布局
    QNFlexDirectionRow,             // 线性布局
    QNFlexDirectionRowReverse,      // 线性反向布局
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
    QNJustifySpaceBetween,  // 两端对齐，间隔平分
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
    QNWrapNoWrap,   // 不换行
    QNWrapWrap,     // 换行
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

- (QNLayout * (^)(QNFlexDirection attr))flexDirection;

- (QNLayout * (^)(QNJustify attr))justifyContent;

- (QNLayout * (^)(QNAlign attr))alignContent;
- (QNLayout * (^)(QNAlign attr))alignItems;
- (QNLayout * (^)(QNAlign attr))alignSelf;

- (QNLayout * (^)(QNPositionType attr))positionType;

- (QNLayout * (^)(QNWrap attr))flexWrap;

- (QNLayout * (^)(CGFloat attr))flexGrow;

- (QNLayout * (^)(CGFloat attr))flexShrink;
- (QNLayout * (^)(CGFloat attr))flexBasiss;

- (QNLayout * (^)(UIEdgeInsets attr))position;

- (QNLayout * (^)(UIEdgeInsets attr))margin;
- (QNLayout * (^)(CGFloat attr))marginT;
- (QNLayout * (^)(CGFloat attr))marginL;
- (QNLayout * (^)(CGFloat attr))marginB;
- (QNLayout * (^)(CGFloat attr))marginR;

- (QNLayout * (^)(UIEdgeInsets attr))padding;
- (QNLayout * (^)(CGFloat attr))paddingT;
- (QNLayout * (^)(CGFloat attr))paddingL;
- (QNLayout * (^)(CGFloat attr))paddingB;
- (QNLayout * (^)(CGFloat attr))paddingR;

- (QNLayout * (^)(CGFloat attr))width;
- (QNLayout * (^)(CGFloat attr))height;

- (QNLayout * (^)(CGFloat attr))minWidth;
- (QNLayout * (^)(CGFloat attr))minHeight;
- (QNLayout * (^)(CGFloat attr))maxWidth;
- (QNLayout * (^)(CGFloat attr))maxHeight;

- (QNLayout * (^)(CGSize attr))size;
- (QNLayout * (^)(CGSize attr))minSize;
- (QNLayout * (^)(CGSize attr))maxSize;

- (QNLayout * (^)(CGFloat attr))aspectRatio;

/**
 自适应大小（最大尺寸），必须是叶子结点并且继承自协议QNLayoutCalProtocolc设置才生效
 */
- (QNLayout * (^)(void))wrapContent;

/**
 自适应大小（最小尺寸），必须是叶子结点并且继承自协议QNLayoutCalProtocolc设置才生效
 */
- (QNLayout * (^)(void))wrapExactContent;

/**
 固定尺寸布局（只能是UIView才可以使用）
 */
- (QNLayout * (^)(void))wrapSize;

/**
 自身位于父元素中间位置（交叉轴）
 */
- (QNLayout * (^)(void))alignSelfCenter;

/**
 自身位于父元素最后位置（交叉轴）
 */
- (QNLayout * (^)(void))alignSelfEnd;

/**
 内部子元素居中排列（交叉轴）
 */
- (QNLayout * (^)(void))alignItemsCenter;

/**
 内部子元素居中排列（主轴）
 */
- (QNLayout * (^)(void))justifyCenter;

/**
 两端对齐，子元素之间间隔相等（主轴）
 */
- (QNLayout * (^)(void))spaceBetween;

/**
 使用绝对布局方式
 */
- (QNLayout * (^)(void))absoluteLayout;

- (QNLayout * (^)(NSArray*))children;

- (void)applyLayoutCache:(QNLayoutCache *)layoutCache;

- (QNLayoutCache *)layoutCache;

@end
NS_ASSUME_NONNULL_END
