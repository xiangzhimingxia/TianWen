//
//  Toolbox.m
//  BaseProject
//
//  Created by QiJia on 2017/8/3.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "Toolbox.h"
#import "UIImage+FixOrientation.h"

@implementation Toolbox

+(BOOL)isValidateEmail:(NSString *)email

{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

+ (NSString *)calculatePriceWith:(NSString *)photoType
                   photoCount:(NSInteger)photoCount
                    trueCount:(NSInteger)trueCount
                   clothCount:(NSInteger)clothCount
                  peopleCount:(NSInteger)peopleCount
                     dayCount:(CGFloat)dayCount
                isHaveDresser:(BOOL)haveDresser
                     isStudio:(NSString *)isStudio
                       remark:(NSString *)remakr
                       isForeign:(BOOL)isForeign{
    CGFloat price = 0.0;
    
    
    if (isForeign) {
        if ([remakr isEqualToString:@"需要送机"] || [remakr isEqualToString:@"需要接机"]) {
            price += 150.0;
        }else if ([remakr isEqualToString:@"需要接送机"]){
            price += 300.0;
        }else if ([remakr isEqualToString:@"无特殊要求"]){
            price = 0.0;
        }
        
        if ([photoType isEqualToString:@"婚纱摄影"]) {
            if ([isStudio isEqualToString:@"艺术家接单"]) {
                price += clothCount * 300 + 20 * trueCount;
                return [NSString stringWithFormat:@"%.2lf",price];
            }else if ([isStudio isEqualToString:@"影楼接单"]){
                price += clothCount * 1500 + 30 * trueCount;
                return [NSString stringWithFormat:@"%.2lf",price];
            }else
            {//普通用户
                if (trueCount <= 10 * clothCount) {
                    trueCount = 0;
                }else{
                    trueCount = trueCount - 10 * clothCount;
                }
                price += clothCount * 1500 + 120 * trueCount;
                NSLog(@"price = %.2lf",price);
                return [NSString stringWithFormat:@"%.2lf",price];
            }
        }else if ([photoType isEqualToString:@"日常摄影"]){
            price += (int)dayCount * 3500 + (dayCount - (int)dayCount)/0.5 * 2000;
            if (haveDresser) {
                price += (int)dayCount * 1200 + (dayCount - (int)dayCount)/0.5 * 1200;
            }
        }
    }else{
        if ([remakr isEqualToString:@"需要送机"] || [remakr isEqualToString:@"需要接机"]) {
            price += 100.0;
        }else if ([remakr isEqualToString:@"需要接送机"]){
            price += 200.0;
        }else if ([remakr isEqualToString:@"无特殊要求"]){
            price = 0.0;
        }

        
        if ([photoType isEqualToString:@"婚纱摄影"]) {
            if ([isStudio isEqualToString:@"艺术家接单"]) {
                price += clothCount * 80 + 6 * trueCount;
                return [NSString stringWithFormat:@"%.2lf",price];
            }else if ([isStudio isEqualToString:@"影楼接单"]){
                price += clothCount * 500 + 10 * trueCount;
                return [NSString stringWithFormat:@"%.2lf",price];
            }else
            {
                if (trueCount <= 10 * clothCount) {
                    trueCount = 0;
                }else{
                    trueCount = trueCount - 10 * clothCount;
                }
                price += clothCount * 500 + 50 * trueCount;
                NSLog(@"price = %.2lf",price);
                return [NSString stringWithFormat:@"%.2lf",price];
            }
        }else if ([photoType isEqualToString:@"电商摄影"]){
            price += photoCount * 30;
            if (haveDresser) {
                price += (int)dayCount * 200 + (dayCount - (int)dayCount)/0.5 * 120;
            }
        }else if ([photoType isEqualToString:@"创意广告"]){
            price += (int)dayCount * 10000 + (dayCount - (int)dayCount)/0.5 * 6000;
            if (haveDresser) {
                price += (int)dayCount * 400 + (dayCount - (int)dayCount)/0.5 * 400;
            }
        }else if ([photoType isEqualToString:@"日常摄影"]){
            price += (int)dayCount * 1000 + (dayCount - (int)dayCount)/0.5 * 550;
            if (haveDresser) {
                price += (int)dayCount * 400 + (dayCount - (int)dayCount)/0.5 * 400;
            }
        }
    }
    
    return [NSString stringWithFormat:@"%.2lf",price];
}

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font
{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size.width;
}
+ (CGFloat)singLineTextSizeWithText:(NSString *)text font:(NSUInteger)font{
    CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]}].width;
    return width;
}

+ (CGFloat)getHeightForText:(NSString*)string Font:(CGFloat)font spaceWidth:(CGFloat)spaceWidth
{
    CGFloat innerMaxWidth = 0.0f;
    CGFloat conHeight = 0.0f;
    CGSize textSize;
    innerMaxWidth = kScreenWidth - spaceWidth;
    textSize = [string boundingRectWithSize:CGSizeMake(innerMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    conHeight = textSize.height;
    return conHeight;
}


+ (void)registerCellNibWithTableView:(UITableView *)tableView Cellidenfers:(NSArray *)cellidenfers registerSuccess:(void (^)(BOOL))registerSuccess
{
    if (cellidenfers.count > 0) {
        UINib *nib;
        for (NSString *cellid in cellidenfers) {
            nib = [UINib nibWithNibName:cellid bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellid];
        }
        registerSuccess(YES);
    }
}

+ (NSDate*)getMaxDayFromNow:(NSInteger)maxDay{
    NSInteger dis = maxDay; //前后的天数
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    
    if(dis!=0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*dis ];
        //or
        //theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    }else{
        theDate = nowDate;
    }
    return theDate;
}

+ (UIImage *)scaleImage:(UIImage *)image maxSize:(CGSize)maxSize
{
    image = [image fixOrientation];
    CGSize originalSize = image.size;
    if ((originalSize.width <= maxSize.width) &&
        (originalSize.height <= maxSize.height))
    {
        return image;
    }
    else
    {
        CGFloat ratio = 0;
        if (originalSize.width > originalSize.height)
        {
            ratio = maxSize.width / originalSize.width;
        }
        else
        {
            ratio = maxSize.height / originalSize.height;
        }
        CGRect rect = CGRectMake(0, 0, originalSize.width * ratio,
                                 originalSize.height * ratio);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}
+ (UIWebView *)jumpToQQService{

    // 判断手机是否安装QQ
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        NSLog(@"install--");
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        // 提供uin, 你所要联系人的QQ号码
        NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"501863587"];
        NSURL *url = [NSURL URLWithString:qqstr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        return webView;
    }else{
        
        NSLog(@"no---");
        return nil;
    }
}
+(NSString *)dataStringFromTimestamp:(NSString *)timestamp format:(NSString *)format{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat = format;
    NSString*timeStr = [matter stringFromDate:date];
    //    NSLog(@"%@",timeStr);//2016-04-29 10:23
    return  timeStr;
}
+ (NSString *)dataStringFromTimestamp:(NSString *)timestamp{
    
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat =@"YYYY-MM-dd";
    
    NSString*timeStr = [matter stringFromDate:date];
//    NSLog(@"%@",timeStr);//2016-04-29 10:23
    return  timeStr;
}
+ (NSString *)dataChineseFromTimestamp:(NSString *)timestamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat =@"YYYY年MM月dd日 HH:mm";
    
    NSString*timeStr = [matter stringFromDate:date];
    return  timeStr;
}
+ (UIImage *)getImageFromURL:(NSString *)fileURL
{
    
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
+ (NSString *)moneyTransform:(NSString *)money{

    NSInteger m = [money integerValue];
    
    NSInteger whole = 0;
    NSInteger dec = 0;
    if (m>10000) {
        whole = m/10000;
        dec = m%10000;
        return [NSString stringWithFormat:@"%ld.%ld万",whole,dec/1000];
    }else{
        return [NSString stringWithFormat:@"%@元",money];
    }
}
#pragma 密码验证
+ (BOOL)validatePwd:(NSString *)pwd
{
    NSString *pwdRegex = @"^\\d{6}$";  // (6个连续数字,以数字开头,以数字结尾)
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    
    BOOL isMatch= [pwdTest evaluateWithObject:pwd];
    
    if (!isMatch) {
        NSLog(@"请输入6位密码");
        return NO;
    }
    return isMatch;
}
+ (BOOL)isMobile:(NSString *)mobileNumbel{
//    NSString *regex =@"^((1[3-8][0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if ([pred evaluateWithObject:mobileNumbel]) {
//        return YES;
//    }else{
//        return NO;
//    }
    NSString *mobileNum = mobileNumbel;
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
//    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    // 有些新电话号码会被判断为不是正常的电话号码，如166，199，198等这些开头的电话号码，注释掉上面加入电信中
    NSString *CT = @"^1(3[3]|4[9]|53|6[6]|9[9]|9[8]|7[037]|8[019])\\d{8}$";

    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (UIImage *)cutDownPichture:(UIImage *)img scale:(CGFloat)scale{
    UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(img, scale)];
    return image;
}
+ (NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    [attrString addAttribute:NSForegroundColorAttributeName value:BtnSelectedColor range:NSMakeRange(5,needText.length - 5)];
    [attrString addAttribute:NSForegroundColorAttributeName value:TextBlackColor range:NSMakeRange(0,5)];
    //    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
    return attrString;
}
+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
//    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}
+ (UITextField *)textFieldSubStringWith:(UITextField *)textField toLenth:(NSInteger)maxLenth{

    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    
        NSInteger MAX_STARWORDS_LENGTH = maxLenth;
        if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
        {
            
            //获取高亮部分
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position)
            {
                if (toBeString.length > MAX_STARWORDS_LENGTH)
                {
                    textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
            }
            
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    return  textField;
}

//+ (void)loginSucessAndSetJpushAlias//- 极光推送别名处理
//{
//    NSString *usid = [DemoGlobalClass sharedInstance].userId;//用户id
//    NSString *mac = [ShareMethod getIDFVidentifierForVendor];//设备唯一码
//    __weak typeof(self) weakSelf = self;
//    [JPUSHService setAlias:mac completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"%lu----%@---",iResCode,iAlias);
//
//        if (iResCode == 6002) {//设置超时 重新设置
//            [[weakSelf class] performSelector:@selector(loginSucessAndSetJpushAlias) withObject:nil afterDelay:8.0];//8秒后重新请求
//        }
//
//    } seq:12000];
//
//    if ([mac isKindOfClass:[NSNull class]]) {
//        mac = @"";
//    }
//
//    NSDictionary *params = @{
//                   @"userId": usid,
//                   @"mac": mac,
//                   };
//    [HttpManager postWithURL:updateMac_Mine andParams:params returnBlcok:^(NSError *error, id obj) {
//        if (!error) {
//
//            if ([obj[codeKey] integerValue] == MSG_SUCCESS) {
//                NSLog(@"上传mac成功");
//            }else{
//                [JRToast showWithText:[obj[@"msg"] length]>0?obj[@"msg"]:@"网络错误"];
//            }
//        }
//    }];
//}
//
//+ (void)loginQuitAndDelJpushAlias//- 极光推送别名处理
//{
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"%lu----%@---",iResCode,iAlias);
//    } seq:13000];
//}

@end
