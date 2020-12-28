//
//  JLKFUtil.h
//  ClassPamper
//
//  Created by Xcode on 16/8/19.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLKFUtil : NSObject

/*
 *  用正则判断用户名，是否2－16位
 */
+ (BOOL) checkInputUserName:(NSString *)text;


/*
 *  用正则判断邮箱
 */
+ (BOOL) checkInputEmail:(NSString *)text;

/*
 *  用正则判断密码，是否6－16位
 */
+ (BOOL) checkInputPassword:(NSString *)text;

/*
 *  得到字符串长度 中英文混合情况下
 */
+(int)lengthToInt:(NSString*)string;

/*
 *  将字符串进行MD5加密，返回加密后的字符串
 */
+ (NSString *) MD5Hash:(NSString*) aString;

/*
 *  用正则判断手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isMobile:(NSString *)mobileNumbel;

/*
 *  URL解码
 */
+ (NSString *)URLDecodedString:(NSString*)stringURL;

///*
// *  图片变灰
// */
//+ (UIImage *)grayscaleWithImage:(UIImage *)image;

///*
// *  判断字符串是否是数字组成
// */
+ (BOOL)isNumberStr:(NSString*)string;

/*
 *  判断手机型号是否是iPhone5；
 */
+ (BOOL)isiPhone5Height:(NSInteger)height;

/*
 *  判断是否是身份证
 *  需要-(BOOL)isNumberStr:(NSString*)string配合
 */
+(BOOL)isPersonCard:(NSString*)string;

/*
 *  判断String中是否都是数字
 */
-(BOOL)isNumberStr:(NSString*)string;
/**
 *  判断是否是网址
 *
 *  @param aString 网址
 *
 *  @return 布尔值
 */
+ (BOOL)isWeblinker:(NSString *)aString;

/**
 *  base64转字符串
 *
 *  @param base64 base64编码
 *
 *  @return 字符串
 */
+(NSString *)textStrFrombase64:(NSString *)base64;

/**
 *  字符串转base64
 *
 *  @param str 字符串
 *
 *  @return base64
 */
+(NSString *)base64FromStr:(NSString *)str;

/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate;

/**
 *  背景色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  更换图片路径
 */
+ (NSString *)changePicURL:(NSString *)oldStr;

/// md5双加密(小写)
+ (NSString *)MD5md5Hash:(NSString *) aString;

/**
 判断日期的先后
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


/**
 获取当前NSDate
 */
+(NSDate *)getCurrentDate;


/**
 毫秒时间戳转换为NSDate
 */
+(NSDate *)exchangeTimeStamp:(NSString *)timeStamp;

/**
 毫秒时间戳转比较时间
 */
+(NSString *)stampToChangeTime:(NSString *)stamp;

/**
 时间戳转时间

 @param stamp <#stamp description#>
 @return <#return value description#>
 */
+(NSString *)stampToTimeStr:(NSString *)stamp WithFormatter:(NSString *)formatterStr;

/**
 时间戳转时间(区分秒或毫秒)

 @param stamp <#stamp description#>
 @return <#return value description#>
 */
+(NSString *)stampToTimeStr:(NSString *)stamp WithFormatter:(NSString *)formatterStr WithSeconds:(BOOL)isSeconds;

/**
 时间转时间戳

 @param time 时间
 @return 时间戳
 */
+(NSString *)timeToStampStr:(NSString *)time WithFormatter:(NSString *)formatterStr;

/**
 将生日转为年龄

 @param bornStr <#time description#>
 @param formatterStr <#formatterStr description#>
 @return <#return value description#>
 */
+(NSString *)dateToOld:(NSString *)bornStr WithFormatter:(NSString *)formatterStr;


/**
 获取当前周的周一和周日的时间

 @return <#return value description#>
 */
+ (NSString *)getWeekTime;

/**
 获取UserDefaults数据

 @param keyStr UserDefaults Key值
 @return UserDefaults Value值
 */
+(NSData *)getUserDefaultsValuesFromKeyStr:(NSString *)keyStr;

+(void)setValueToUserDefaultsForKeyStr:(NSString *)keyStr AndWithData:(NSData *)data;


/**
 url编码转换

 @param urlStr URL
 @return 编码转换URL
 */
+(NSString *)changeRightUrlEncordFromStr:(NSString *)urlStr;

/**
 富文本

 @param str <#str description#>
 @param font <#font description#>
 @param color <#color description#>
 @param range <#range description#>
 @return <#return value description#>
 */
+(NSMutableAttributedString *)attributeWithStr:(NSString *)str AndWithFont:(UIFont *)font AndWithColor:(UIColor *)color AndRange:(NSRange )range;

/**
 如果有两位小数不为0则保留两位小数，如果有一位小数不为0则保留一位小数，否则显示整数
 */
+ (NSString *)formatFloat:(double)f;

//判断身份证号码
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;

//判断银行卡号码
+ (BOOL) checkCardNo:(NSString*) cardNo;
//判断卡号所属银行
+(NSString *)backbankenameWithBanknumber:(NSString *)banknumber;

//图片压缩
+(NSData *)imageData:(UIImage *)myimage;

/**
 获取字符串中多个相同字符串的所有range

 @param initialArray 空数组或有值数组
 @param initialText 源字符串
 @param regexString 查询字符串
 */
+ (void)searchAllTextRangeWithInitialArray:(NSMutableArray*)initialArray initialText:(NSString*)initialText regexString:(NSString*)regexString;

/**通过CAShapeLayer方式绘制虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;


/**
 全切圆

 @param view <#view description#>
 */
+(void)viewmasksAllToBounds:(UIView *)view;


/**
 左边切圆

 @param view <#view description#>
 */
+(void)viewmasksLeftToBounds:(UIView *)view;

/**
 右边切圆

 @param view <#view description#>
 */
+(void)viewmasksRightToBounds:(UIView *)view;


/**
 上面切圆

 @param view <#view description#>
 */
+(void)viewmasksTopToBounds:(UIView *)view;

/**
 下面切圆

 @param view <#view description#>
 */
+(void)viewmasksBottomToBounds:(UIView *)view;


/**
 *  转换wav到mp3
 *
 *  @param aWavPath  wav文件路径
 *  @param aSavePath mp3保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)ConvertWavToMp3:(NSString *)aWavPath mp3SavePath:(NSString *)aSavePath;

/**
 *  获取语音缓存路径
 *
 *  @return 缓存路径
 */
+ (NSString *)getCacheDirectory;


/**
 图片高斯模糊效果

 @param image 原图片
 @param blur 模糊程度（建议0.5）
 @return 处理完后图片
 */
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

#pragma mark -- 业务逻辑

@end

