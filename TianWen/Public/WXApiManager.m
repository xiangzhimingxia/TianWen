//
//  WXApiManager.m
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

-(void)wechatPayActionWithData:(PayModel *)model{
    
    //调起微信支付
//    PayReq* req             = [[PayReq alloc] init];
//    req.openID              = [dataDic objectForKey:@"appid"];
//    req.partnerId           = [dataDic objectForKey:@"partnerid"];
//    req.prepayId            = [dataDic objectForKey:@"prepayid"];
//    req.nonceStr            = [dataDic objectForKey:@"noncestr"];
//    //                    req.timeStamp           = stamp.intValue;
//    NSString *timeStamp            = [dataDic objectForKey:@"timestamp"];
//    req.timeStamp            = timeStamp.intValue;
//    req.package             = [dataDic objectForKey:@"package"];
//    req.sign                = [dataDic objectForKey:@"sign"];
//
//    [WXApi sendReq:req completion:nil];
    
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = model.appid;
    req.partnerId           = model.partnerid;
    req.prepayId            = model.prepayid;
    req.nonceStr            = model.noncestr;
    //                    req.timeStamp           = stamp.intValue;
    NSString *timeStamp            = model.timestamp;
    req.timeStamp            = timeStamp.intValue;
    req.package             = model.package;
    req.sign                = model.sign;
    
    [WXApi sendReq:req completion:nil];
    
}

@end
