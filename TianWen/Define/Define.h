//
//  Define.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define WEAK(weakSelf)      __weak    __typeof(&*self)weakSelf = self;
#define WEAKSELF @weakify(self);
#define STRONGSELF @strongify(self);

//判断iphoneX
#define KISIphoneX ((int)(([UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width)*100) >= 216)?YES:NO

//适配
#define IPHONE_FIT KMainScreenWidth/375.0

//获取屏幕宽高
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width

#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define KMainSCALE [UIScreen mainScreen].bounds.size.width / 375

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark - 屏幕尺寸
#define kScale  KMainScreenWidth/375 //适配比例
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


//导航栏高度 iPhone X系列为88
#define SafeAreaTopHeight ((KISIphoneX) ? 88 : 64)
#define SafeAreaBottomHeight ((KISIphoneX) ? 34 : 0)
#define StatusBarHeight ((KISIphoneX) ? 44 : 20)


static NSInteger IPHONEX_TOP_HEIGHT = 24;
static NSInteger IPHONEX_BOTTOM_HEIGHT = 34;

//获取视图宽高
#define KViewWidth(a) (a).frame.size.width

#define KViewHeiht(a) (a).frame.size.height

#define NUMBERS @"0123456789\n"

//颜色
#define RGBA_COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//颜色值 HEX
#define KHEXCOLOR(h,a) [UIColor hexStringToColor:(h) withAlpha:(a)]
#define SYHEXCOLOR(h) [UIColor hexStringToColor:(h) withAlpha:(1.0)]
#define SYRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:(a)]

/**
 *  进制颜色转RGB
 */
#define JColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define JColorFromRGBAndAlpha(rgbValue,num) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:num]

#define MainBackgroundColor UIColorHex(0xFAFAFA)
#define BACKGROUNDVIEW_COLOR  JColorFromRGB(0xFAFAFA)
#define MAINRED_COLOR  JColorFromRGB(0xfc3973)
#define MAINWORDGRAY_COLOR  JColorFromRGB(0x333333)
#define DARK_GRAY_BG  RGBA_COLOR(125 , 125, 125)
#define GRAY_SEP      RGBA_COLOR(223 , 223, 223)
#define GREEN_COLOR  RGBA_COLOR(7 , 186, 8)
#define BACK_TABLE_LIGHTGRAY   JColorFromRGB(0xf2f2f2)
#define TextBlackColor JColorFromRGB(0x0C0C0C)
#define TextGrayColor JColorFromRGB(0x9C9C9C)
#define TextRedColor    JColorFromRGB(0xD94850)
#define TextBlueColor    JColorFromRGB(0x3298DB)
#define TextLightGrayColor     JColorFromRGB(0x747474)
#define PECENT_GRAY(per)  [UIColor colorWithWhite:per alpha:1.0] //返回一个百分比灰度的颜色
#define BtnSelectedColor UIColorHex(0x49CA6D)

#define RGBACOLOR(r,g,b,a)              [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kBgColor                 JColorFromRGB(0x49CA6D)
#define KNavColor                JColorFromRGB(0x49CA6D)
#define KNavColorHalf                JColorFromRGBAndAlpha(0x49CA6D,0.5)
#define kBtnEnableColor         JColorFromRGB(0x6b96f1)      //
#define KBtnNotEnableColor       [kBtnEnableColor colorWithAlphaComponent:0.2f]  //

#define kBtnEnableColorImage         [UIImage imageByColor:KRGBACOLOR(89, 128, 237, 1)]      //
#define KBtnNotEnableColorImage       [UIImage imageByColor:KRGBACOLOR(161, 184, 242, 1)]


//背景色
#define TABLE_BACK_COLOR  RGBA_COLOR(242 , 241, 242)
#define VIEW_BG       RGBA_COLOR(215 , 215, 215)
#define VIEW_TABLE_BG   RGBA_COLOR(248 , 248, 248)

//字体大小
#define KMax_Font 15

#define KMid_Font 14

#define KMin_Font 12

//系统字体大小
#define KSystemFont(a) [UIFont systemFontOfSize:(a)];
#define KBoldFont(a) [UIFont boldSystemFontOfSize:(a)];

//获取字符串长度
#define Attributes(font) @{NSFontAttributeName:[UIFont systemFontOfSize:font],}

#define AttributesBold(font) @{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],}

#define LabelSizeWithStr(str,CGSizeMake,myAttributes) [str boundingRectWithSize:CGSizeMake options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:myAttributes context:nil].size;

#define kIsLogin    @"isLogin"

#define kStr(name) @property (nonatomic,copy) NSString *name
#define kUI(UI,name) @property (nonatomic,strong) UI *name
#define kAS(AS,name) @property (nonatomic,assign) AS name

#define TenNum 10

#define RequestSuccess RequestSuccess

#define ErrorShowInView    @"网络错误，请稍后重试"
#define NoMoreDataShowInView    @"没有更多数据"
#define NoDataShowInView    @"暂无数据"

//当前版本
#define RCDLive_IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

//图片加载
#define KImageName(a) [UIImage imageNamed:(a)]


//腾讯云音视频
#define TXLiveDelegateChange    @"TXLiveDelegateChange"

#endif /* Define_h */
