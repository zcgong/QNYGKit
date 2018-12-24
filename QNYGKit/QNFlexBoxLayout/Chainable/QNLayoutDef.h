//
//  QNLayoutDef.h
//  QQNews
//
//  Created by jayhuan on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#define QN_FB_STRONG                @property(nonatomic, strong)
#define QN_FB_ASSIGN                @property(nonatomic, assign)
#define QN_FB_COPY                  @property(nonatomic, copy)

#define QN_FB_PROP(x,y)             QN_FB_STRONG x *y;
#define QN_FB_ASSIGN_PROP(x,y)      QN_FB_ASSIGN x y;
#define QN_FB_COPY_PROP(x,y)        QN_FB_COPY x *y;

#define QN_LABEL_PROP(y)            QN_FB_PROP(UILabel, y)
#define QN_BUTTON_PROP(y)           QN_FB_PROP(UIButton, y)
#define QN_IMAGEVIEW_PROP(y)        QN_FB_PROP(UIImageView, y)
#define QN_IMAGE_PROP(y)            QN_FB_PROP(UIImage, y)
#define QN_VIEW_PROP(y)             QN_FB_PROP(UIView, y)
#define QN_CALAYER_PROP(y)          QN_FB_PROP(CALayer, y)

#define QN_BOOL_PROP(y)             QN_FB_ASSIGN_PROP(BOOL, y)
#define QN_INTEGER_PROP(y)          QN_FB_ASSIGN_PROP(NSInteger, y)
#define QN_UINTEGER_PROP(y)         QN_FB_ASSIGN_PROP(NSUInteger, y)
#define QN_FLOAT_PROP(y)            QN_FB_ASSIGN_PROP(CGFloat, y)
#define QN_TIMEINTERVAL_PROP(y)     QN_FB_ASSIGN_PROP(NSTimeInterval, y)

#define QN_STRING_PROP(y)           QN_FB_COPY_PROP(NSString, y)
#define QN_ARRAY_PROP(y)            QN_FB_COPY_PROP(NSArray, y)
#define QN_M_STRING_PROP(y)         QN_FB_PROP(NSMutableString, y)
#define QN_M_ARRAY_PROP(y)          QN_FB_PROP(NSMutableArray, y)

#define RECT_WH(width, height)      CGRectMake(0, 0, width, height)
#define QN_INSETS(t,l,b,r)          UIEdgeInsetsMake(t,l,b,r)
#define QN_INSETS_TB(t,b)           UIEdgeInsetsMake(t,0,b,0)
#define QN_INSETS_LR(l,r)           UIEdgeInsetsMake(0,l,0,r)
#define QN_INSETS_TL(t,l)           UIEdgeInsetsMake(t,l,0,0)
#define QN_INSETS_TLBR(s)           UIEdgeInsetsMake(s,s,s,s)
#define QN_INSETS_TB_LR(tb, lr)     UIEdgeInsetsMake(tb,lr,tb,lr)

#define QN_View                     [UIView new]
#define QN_View_Rect(frame)         [[UIView alloc] initWithFrame:frame]
#define QN_Label                    [UILabel new]
#define QN_Label_Rect(frame)        [[UILabel alloc] initWithFrame:frame]
#define QN_ImageView                [UIImageView new]
#define QN_ImageView_Rect(frame)    [[UIImageView alloc] initWithFrame:frame]
#define QN_Button                   [UIButton new]
#define QN_Button_Rect(frame)       [[UIButton alloc] initWithFrame:frame]
