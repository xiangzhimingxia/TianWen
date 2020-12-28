//
//  Toolbox.h
//  BaseProject
//
//  Created by QiJia on 2017/8/3.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toolbox : NSObject
+ (UIWebView *)jumpToQQService;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (NSString *)calculatePriceWith:(NSString *)photoType
                   photoCount:(NSInteger)photoCount
                    trueCount:(NSInteger)trueCount
                   clothCount:(NSInteger)clothCount
                  peopleCount:(NSInteger)peopleCount
                     dayCount:(CGFloat)dayCount
                isHaveDresser:(BOOL)haveDresser
                     isStudio:(NSString *)isStudio
                        remark:(NSString *)remakr
                       isForeign:(BOOL)isForeign;

+ (BOOL)isMobile:(NSString *)mobileNumbel;
+ (CGFloat)singLineTextSizeWithText:(NSString *)text font:(NSUInteger)font;
+ (CGFloat)getHeightForText:(NSString*)string Font:(CGFloat)font spaceWidth:(CGFloat)spaceWidth;
+ (void)registerCellNibWithTableView:(UITableView *)tableView Cellidenfers:(NSArray *)cellidenfers registerSuccess:(void (^)(BOOL))registerSuccess;
+ (NSDate*)getMaxDayFromNow:(NSInteger)maxDay;
+ (UIImage *)scaleImage:(UIImage *)image maxSize:(CGSize)maxSize;
+ (NSString *)dataStringFromTimestamp:(NSString *)timestamp;
+ (NSString *)dataStringFromTimestamp:(NSString *)timestamp format:(NSString *)format;
+ (UIImage *) getImageFromURL:(NSString *)fileURL;
+ (NSString *)moneyTransform:(NSString *)money;
+ (NSString *)dataChineseFromTimestamp:(NSString *)timestamp;
+(UIImage*) createImageWithColor:(UIColor*) color;
+ (UIImage *)cutDownPichture:(UIImage *)img scale:(CGFloat)scale;
+ (BOOL)validatePwd:(NSString *)pwd;
+ (NSMutableAttributedString*)changeLabelWithText:(NSString*)needText;
+ (NSString *)transform:(NSString *)chinese;//转换拼音
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font;//计算文字长度

+ (UITextField *)textFieldSubStringWith:(UITextField *)textField toLenth:(NSInteger)maxLenth;

//+ (void)loginSucessAndSetJpushAlias;//- 极光推送别名处理
//+ (void)loginQuitAndDelJpushAlias;//- 极光推送别名处理
@end
