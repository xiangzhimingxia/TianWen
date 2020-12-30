//
//  AppDelegate.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/12.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "AppDelegate.h"
#import "JLKFLuanchViewController.h"
#import <IQKeyboardManager.h>
#import "LoginViewController.h"
#import "WXApi.h"

//腾讯云IM音视频
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"
#import "TRTCCalling.h"
#import "GenerateTestUserSig.h"
//白板
#import <TEduBoard/TEduBoard.h>

//自用组件
#import "ReceiveLiveView.h"
#import "OtherModel.h"
#import "ImSDK.h"

@interface AppDelegate ()<TRTCCallingDelegate,V2TIMSimpleMsgListener,TEduBoardDelegate,WXApiDelegate>

@property (nonatomic, strong) ReceiveLiveView *receiveView;

@property (nonatomic, assign) int roomId;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *userId; //对方的userId

@property (nonatomic, strong) TEduBoardController *boardController;

kUI(NSDate, firstDate);

@end

@implementation AppDelegate

-(ReceiveLiveView *)receiveView{
    if (!_receiveView) {
        _receiveView = [[[NSBundle mainBundle]loadNibNamed:@"ReceiveLiveView" owner:self options:nil] lastObject];
        _receiveView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight + SafeAreaBottomHeight);
    }
    return _receiveView;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    [self setTencentLivePush];
    [self initIponeXAutolayer];
    [self setupKeyboard];
    [self addNotificationAction];
    [self setPaymentAction];
    [self initRootViewController];
    
    return YES;
}

- (void)initRootViewController
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if(![userDef boolForKey:@"LoadGuide"]) {
        //        if(YES) {
        JLKFLuanchViewController *luanchVC =[[JLKFLuanchViewController alloc] init];
        self.window.rootViewController = luanchVC;
        [self.window makeKeyAndVisible];
    }
    else {
        if (User.isLogin) {
//            User.token = @"tw-ol6wrbRdr9pN2JTXf2OZ2Q==";
//            [User updateLocalUser];
            
            [self loginTencentLiveVideo];
            
        self.tabBarVc = [[RootViewController alloc]init];
        self.window.rootViewController = self.tabBarVc;
        //    显示窗口
        [self.window makeKeyAndVisible];
        }else{
            LoginViewController * loginVC =[[LoginViewController alloc] init];
            JLKFBaseNavigationController * loginNav = [[JLKFBaseNavigationController alloc] initWithRootViewController:loginVC];
            self.window.rootViewController = loginNav;
            [self.window makeKeyAndVisible];
        }
    }
}

-(void)addNotificationAction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againTXLiveDelegateAction:) name:TXLiveDelegateChange object:nil];
}

-(void)againTXLiveDelegateAction:(NSNotification *)noti{
    // 1.监听回调
    [[TRTCCalling shareInstance] addDelegate:self];
    if (noti.object != nil) {
        NSDictionary *msgDic = (NSDictionary *)noti.object;
        self.roomId = [msgDic[@"classId"] intValue];
        self.orderId = msgDic[@"orderId"];
    }
}

-(void)getUserInfo:(NSString *)uid{
    [HttpManager getWithURL:userHeadPic_Mine andParams:@{@"userId":uid} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            OtherModel *model = [OtherModel mj_objectWithKeyValues:obj[dataKey]];
            if (model.userHeadPic.length > 0) {
                [self.receiveView.holdImg sd_setImageWithURL:[NSURL URLWithString:model.userHeadPic]];
                [self.receiveView.headBackImg sd_setImageWithURL:[NSURL URLWithString:model.userHeadPic]];
                self.receiveView.nameLb.text = model.nickName;
                //创建毛玻璃
                
                UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                
                UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
                
                effe.frame = CGRectMake(0, 0, self.receiveView.headBackImg.frame.size.width,self.receiveView.headBackImg.frame.size.height);
                
//                effe.layer.masksToBounds = YES;
//
//                effe.layer.cornerRadius = 5;
                
                effe.alpha = 0.6;
                
                [self.receiveView.headBackImg addSubview:effe];
            }
        }
    }];
}

#pragma mark - Setting
-(void)initIponeXAutolayer{
    
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UITableView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
         [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        
    }
}
- (void)setupKeyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor =NO; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar =NO; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
}

-(void)setPaymentAction{
    //向微信注册
    [WXApi registerApp:@"wxa495a7fa18d87be8"
         universalLink:@"https://tellwinedu.com/"];
}

// 将NSlog打印信息保存到Document目录下的文件中（第三方已生成的Log直接Download Container后显示包内容查找）
- (void)redirectNSlogToDocumentFolder
{ NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];
    // 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil]; // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);}
/*******************************************************************************/
// 当真机连接Mac调试的时候把这些注释掉，否则log只会输入到文件中，而不能从xcode的监视器中看到。
// 如果是真机就保存到Document目录下的drm.log文件中 UIDevice *device = [UIDevice currentDevice];
//if (![[device model] isEqualToString:@"iPad Simulator"]) {
//    // 开始保存日志文件
//    [self redirectNSlogToDocumentFolder]; }
/*******************************************************************************/


//腾讯云音视频推送
-(void)setTencentLivePush{
//    [TRTCCalling shareInstance].imBusinessID = your business ID;
//    [TRTCCalling shareInstance].deviceToken =  deviceToken;
}

//登录腾讯云IM
-(void)loginTencentLiveVideo{
    
    NSString *sigStr = [GenerateTestUserSig genTestUserSig:User.userId];
    [[TRTCCalling shareInstance] login:SDKAPPID user:User.userId userSig:sigStr success:^{
        NSLog(@"Video call login success.");
//        NSLog(@"User.userId === %@,sigStr ==== %@",User.userId,sigStr);
    } failed:^(int code, NSString *error) {
        NSLog(@"Video call login failed.");
        [MBProgressHUD showMessage:@"未能登录IM，请重新登录！"];
    }];
    
    // 1.监听回调
    [[TRTCCalling shareInstance] addDelegate:self];
    
    [[V2TIMManager sharedInstance] addSimpleMsgListener:self];
}

#pragma mark - TRTCCallingDelegate
// 接听/拒绝
// 此时 B 如果也登录了IM系统，会收到 onInvited(A, null, false) 回调
// 可以调用 TRTCCalling的accept方法接受 / TRTCCalling的reject 方法拒绝
-(void)onInvited:(NSString *)sponsor
         userIds:(NSArray<NSString *> *)userIds
     isFromGroup:(BOOL)isFromGroup
        callType:(CallType)callType {
    
    NSLog(@"sponsor === %@,userIds ==== %@",sponsor,userIds);
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus != AVAuthorizationStatusAuthorized) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        }];
    }
    
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus != AVAuthorizationStatusAuthorized) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        }];
    }
    
    self.userId = sponsor;
    
    if (User.isAnswer) {
        [self removeReceiveView];
    }
    
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    self.receiveView.finishBtn.hidden = YES;
    self.receiveView.finishBtn.enabled = NO;
    self.receiveView.myVideoView.hidden = YES;
    self.receiveView.isSecond = NO;
    [self getUserInfo:sponsor];
    [keyWin addSubview:self.receiveView];
    
    [self.receiveView setFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight + SafeAreaBottomHeight)];
    
    if (User.isAnswer) {
        self.receiveView.isSecond = YES;
        [[TRTCCalling shareInstance] accept];
        self.firstDate = [JLKFUtil getCurrentDate];
        if (callType == CallType_Audio) {
            self.receiveView.describeLb.hidden = YES;
            self.receiveView.answerView.hidden = YES;
            self.receiveView.finishBtn.hidden = NO;
            self.receiveView.finishBtn.enabled = YES;
            self.receiveView.chooseView.hidden = YES;
        }else if(callType == CallType_Video){
            self.receiveView.infoView.hidden = YES;
            self.receiveView.myVideoView.hidden = NO;
            self.receiveView.answerView.hidden = YES;
            self.receiveView.finishBtn.hidden = NO;
            self.receiveView.finishBtn.enabled = YES;
            self.receiveView.chooseView.hidden = YES;
            
            //打开自己的摄像头
            [[TRTCCalling shareInstance] openCamera:true view:self.receiveView.myVideoView];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self.receiveView.acceptBtn setTapActionWithBlock:^{
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus != AVAuthorizationStatusAuthorized) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            return ;
        }
        
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (videoAuthStatus != AVAuthorizationStatusAuthorized) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            }];
            return;
        }
        
        [[TRTCCalling shareInstance] accept];
        if (callType == CallType_Audio) {
            if (User.isAnswer) {
                weakSelf.receiveView.describeLb.hidden = YES;
                weakSelf.receiveView.answerView.hidden = YES;
                weakSelf.receiveView.finishBtn.hidden = NO;
                weakSelf.receiveView.finishBtn.enabled = YES;
                weakSelf.receiveView.chooseView.hidden = YES;
            }else{
                weakSelf.receiveView.chooseView.hidden = NO;
                weakSelf.receiveView.describeLb.hidden = YES;
                weakSelf.receiveView.answerView.hidden = YES;
                weakSelf.receiveView.finishBtn.hidden = YES;
                weakSelf.receiveView.finishBtn.enabled = NO;
            }
            
        }else if(callType == CallType_Video){
            weakSelf.receiveView.describeLb.text = @"邀请你进行视频通信...";
            weakSelf.receiveView.infoView.hidden = YES;
            weakSelf.receiveView.myVideoView.hidden = NO;
            weakSelf.receiveView.answerView.hidden = YES;
            weakSelf.receiveView.finishBtn.hidden = NO;
            weakSelf.receiveView.finishBtn.enabled = YES;
            weakSelf.receiveView.chooseView.hidden = YES;
            
            //打开自己的摄像头
            [[TRTCCalling shareInstance] openCamera:true view:self.receiveView.myVideoView];
        }
    }];
    
    [self.receiveView.refuseBtn setTapActionWithBlock:^{
        // 拒绝
        [[TRTCCalling shareInstance] reject];
        [weakSelf removeReceiveView];
    }];
    
    [self.receiveView.finishBtn setTapActionWithBlock:^{
        
        // 挂断
        [[TRTCCalling shareInstance] hangup];
        
        if (User.isAnswer) {
            [weakSelf removeReceiveView];
            [weakSelf answerFinishNet];
        }else{
            [weakSelf removeReceiveView];
            [weakSelf popUpQuestionView];
        }
    }];
    
    //选择解答方式
    [self.receiveView.voiceBtn setTapActionWithBlock:^{
       
        weakSelf.receiveView.isSpecial = YES;
        weakSelf.receiveView.isSecond = YES;
        
        // 挂断
        [[TRTCCalling shareInstance] hangup];
        weakSelf.receiveView.describeLb.hidden = YES;
        weakSelf.receiveView.answerView.hidden = YES;
        weakSelf.receiveView.finishBtn.hidden = NO;
        weakSelf.receiveView.finishBtn.enabled = YES;
        weakSelf.receiveView.chooseView.hidden = YES;
        weakSelf.receiveView.myVideoView.hidden = YES;
        
        // 发起语音通话
        [[TRTCCalling shareInstance] call:weakSelf.userId type:CallType_Audio];
        
        
        [weakSelf chooseAnswerTypeNetWithType:@"1"];
    }];
    
    [self.receiveView.videoBtn setTapActionWithBlock:^{
        
        weakSelf.receiveView.isSpecial = YES;
        weakSelf.receiveView.isSecond = YES;
        
        // 挂断
        [[TRTCCalling shareInstance] hangup];
        
        weakSelf.receiveView.infoView.hidden = YES;
        weakSelf.receiveView.answerView.hidden = YES;
        weakSelf.receiveView.finishBtn.hidden = NO;
        weakSelf.receiveView.finishBtn.enabled = YES;
        weakSelf.receiveView.chooseView.hidden = YES;
        weakSelf.receiveView.myVideoView.hidden = NO;
        
        // 发起视频通话
        [[TRTCCalling shareInstance] call:weakSelf.userId type:CallType_Video];
        
        //打开自己的摄像头
        [[TRTCCalling shareInstance] openCamera:true view:self.receiveView.myVideoView];
        
        
        [weakSelf chooseAnswerTypeNetWithType:@"2"];
    }];
    
    [self.receiveView.drawBtn setTapActionWithBlock:^{
       
        weakSelf.receiveView.isSpecial = YES;
        weakSelf.receiveView.isSecond = YES;
        
        // 挂断
        [[TRTCCalling shareInstance] hangup];
        weakSelf.receiveView.isDraw = YES;
        weakSelf.receiveView.infoView.hidden = YES;
        weakSelf.receiveView.answerView.hidden = YES;
        weakSelf.receiveView.chooseView.hidden = YES;
        weakSelf.receiveView.myVideoView.hidden = YES;
        [weakSelf.receiveView.finishBtn removeAllTargets];
        weakSelf.receiveView.finishBtn.hidden = NO;
        weakSelf.receiveView.finishBtn.enabled = YES;
        
        [weakSelf creatGroupActionWithClassId:self.roomId];
        
        
        [weakSelf chooseAnswerTypeNetWithType:@"3"];
        
        [weakSelf.receiveView.finishBtn setTapActionWithBlock:^{
            NSDictionary *msgDic = @{@"classId":@(weakSelf.roomId),@"orderId":weakSelf.orderId,@"type":@(1003)};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgDic options:0 error:nil];
            
            [weakSelf sendIMMessgeWithJsonData:jsonData];
            
            if (User.isAnswer) {
                [weakSelf removeReceiveView];
                [weakSelf answerFinishNet];
            }else{
                [weakSelf removeReceiveView];
                [weakSelf popUpQuestionView];
            }
        }];
    }];
}

// 观看对方的画面
// 由于 A 打开了摄像头，B 接受通话后会收到 onUserVideoAvailable(A, true) 回调
- (void)onUserVideoAvailable:(NSString *)uid available:(BOOL)available {
    if (available) {
        self.receiveView.headBackImg.hidden = YES;
        [[TRTCCalling shareInstance] startRemoteView:uid view:self.receiveView.liveView]; // 就可以看到对方的画面了
    } else {
        [[TRTCCalling shareInstance] stopRemoteView:uid]; // 停止渲染画面
    }
}

-(void)onUserEnter:(NSString *)uid{
    self.receiveView.isSpecial = NO;
}

-(void)onNoResp:(NSString *)uid{
    //几乎没有可能性
    if (self.receiveView.isSecond) {
        if (!User.isAnswer) {
            [self againSendOrderNet];
        }
    }
    self.receiveView.isSpecial = NO;
    [MBProgressHUD showMessage:@"暂时无人接听，请稍后重试"];
    [self removeReceiveView];
}

-(void)onCallingCancel:(NSString *)uid{
    //几乎没有可能性
    if (self.receiveView.isSecond) {
        if (!User.isAnswer) {
            [self againSendOrderNet];
        }
    }
    [MBProgressHUD showMessage:@"通话已取消"];
    [self removeReceiveView];
}

-(void)onCallEnd{
    if (self.receiveView.isSecond) {
    if (User.isAnswer) {
        [self answerFinishNet];
    }else{
        [self popUpQuestionView];
    }
    }
    [self removeReceiveView];
}

-(void)onCallingTimeOut{
    if (self.receiveView.isSecond) {
        if (User.isAnswer) {
            [self answerFinishNet];
        }else{
            [self popUpQuestionView];
        }
    }
    [MBProgressHUD showMessage:@"通话已超时取消"];
    [self removeReceiveView];
}

-(void)removeReceiveView{
    if (self.receiveView.isSpecial) {
        return;
    }
    if (self.receiveView.isDraw) {
        //彻底销毁白板并停止计费，请您确保此接口的调用
        [_boardController unInit];
        
        if (!User.isAnswer) {
            NSString *roomIdStr = [@(self.roomId) stringValue];
            [[TIMGroupManager sharedInstance] deleteGroup:roomIdStr succ:^{
                NSLog(@"deleteGroupSuccroomIdStr == %@",roomIdStr);
            } fail:^(int code, NSString *msg) {
                NSLog(@"deleteGroupCode = %d, deleteGroupMsg = %@",code,msg);
            }];
        }
    }
    [self.receiveView removeFromSuperview];
    self.receiveView = nil;
}

//SDK 不可恢复的错误回调
-(void)onError:(int)code msg:(NSString *)msg{
    if (self.receiveView.isSecond) {
        if (User.isAnswer) {
            [self answerFinishNet];
        }else{
            [self popUpQuestionView];
        }
    }
    [MBProgressHUD showMessage:msg];
    [self removeReceiveView];
}

-(void)popUpQuestionView{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的问题是否已解答？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"您的问题是否已解答？"];
    
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, [[hogan string] length])];
    
    [hogan addAttribute:NSForegroundColorAttributeName value:JColorFromRGB(0x0C0C0C) range:NSMakeRange(0, [[hogan string] length])];
    
    [alertController setValue:hogan forKey:@"attributedTitle"];
    
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [defaultAction setValue:KNavColor forKey:@"_titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self againSendOrderNet];
    }];
    
    [cancelAction setValue:JColorFromRGB(0x666666) forKey:@"_titleTextColor"];
    
    [alertController addAction:defaultAction];
    
    [alertController addAction:cancelAction];
    
    [[HttpManager currentViewController] presentViewController:alertController animated:YES completion:nil];
}

-(void)creatGroupActionWithClassId:(int)classId{
    
    TIMCreateGroupInfo *groupInfo = [[TIMCreateGroupInfo alloc] init];
    NSString *roomIdStr = [@(classId) stringValue];
    groupInfo.group = roomIdStr;
    groupInfo.groupName = roomIdStr;
    groupInfo.groupType = @"Public";
    groupInfo.setAddOpt = YES;
    groupInfo.addOpt = TIM_GROUP_ADD_ANY;
    __weak typeof(self) ws = self;
    [[TIMGroupManager sharedInstance] createGroup:groupInfo succ:^(NSString *groupId) {
//        [ws report:TIC_REPORT_CREATE_GROUP_END];
        // 创建 IM 群组成功
        
        [ws creatWhiteboardAction];
        
    } fail:^(int code, NSString *msg) {
        // 创建 IM 群组失败
        NSLog(@"createGroupFailMsg = %@,code = %d",msg,code);
        if (code == 10025) {
            [ws addGroupIMAction];
        }else{
        
        [MBProgressHUD showMessage:msg];
        ws.receiveView.isSpecial = NO;
        [ws removeReceiveView];
        }
    }];
    
}

-(void)creatWhiteboardAction{

    self.receiveView.finishBtn.enabled = NO;
    self.receiveView.finishBtn.userInteractionEnabled = NO;
    
    NSString *sigStr = [GenerateTestUserSig genTestUserSig:User.userId];
    // 创建并初始化白板控制器
    //（1）鉴权配置
    TEduBoardAuthParam *authParam = [[TEduBoardAuthParam alloc] init];
    authParam.sdkAppId = SDKAPPID;
    authParam.userId = User.userId;
    authParam.userSig = sigStr;
    //（2）白板默认配置
    TEduBoardInitParam *initParam = [[TEduBoardInitParam alloc] init];
    _boardController = [[TEduBoardController alloc] initWithAuthParam:authParam roomId:self.roomId initParam:initParam];
    
    [[TRTCCloud sharedInstance] startLocalAudio:TRTCAudioQualityDefault];
    [[TRTCCloud sharedInstance] setAudioRoute:TRTCAudioModeSpeakerphone];
    
//    [_boardController setBoardRatio:[NSString stringWithFormat:@"%ld:%ld",(NSInteger)self.receiveView.liveView.frame.size.width,(NSInteger)self.receiveView.liveView.frame.size.height]];
    
    [_boardController setBoardRatio:@"4:3"];
    
    //（3）添加白板事件回调
    [_boardController addDelegate:self];
    
    if (!User.isAnswer) {
    //发送自定义单聊信息
    NSDictionary *msgDic = @{@"classId":@(self.roomId),@"orderId":self.orderId,@"type":@(1001)};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgDic options:0 error:nil];
    
    [self sendIMMessgeWithJsonData:jsonData];
    }else{
        self.firstDate = [JLKFUtil getCurrentDate];
    }
}

-(void)addGroupIMAction{
    __weak typeof(self) weakSelf = self;
    NSString *roomIdStr = [@(self.roomId) stringValue];
    [[TIMGroupManager sharedInstance] joinGroup:roomIdStr msg:nil succ:^{
        // 加入 IM 群组成功
        // 此时可以调用白板初始化接口创建白板
        if (User.isAnswer) {
        
        weakSelf.receiveView.isDraw = YES;
        weakSelf.receiveView.infoView.hidden = YES;
        weakSelf.receiveView.answerView.hidden = YES;
        weakSelf.receiveView.chooseView.hidden = YES;
        weakSelf.receiveView.myVideoView.hidden = YES;
        weakSelf.receiveView.finishBtn.hidden = NO;
        weakSelf.receiveView.finishBtn.enabled = YES;
        UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
        [keyWin addSubview:weakSelf.receiveView];
        
        [weakSelf.receiveView.finishBtn setTapActionWithBlock:^{
            NSDictionary *msgDic = @{@"classId":@(weakSelf.roomId),@"orderId":weakSelf.orderId,@"type":@(1003)};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgDic options:0 error:nil];
            
            [weakSelf sendIMMessgeWithJsonData:jsonData];
            
            [weakSelf removeReceiveView];
        }];
            
        }
        
        [weakSelf creatWhiteboardAction];
        
    } fail:^(int code, NSString *msg) {
        // 加入 IM 群组失败
        NSLog(@"joinGroupFailMsg = %@,code = %d",msg,code);
        if (code == 10013) {
            weakSelf.receiveView.isDraw = YES;
            weakSelf.receiveView.infoView.hidden = YES;
            weakSelf.receiveView.answerView.hidden = YES;
            weakSelf.receiveView.chooseView.hidden = YES;
            weakSelf.receiveView.myVideoView.hidden = YES;
            weakSelf.receiveView.finishBtn.hidden = NO;
            weakSelf.receiveView.finishBtn.enabled = YES;
            UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
            [keyWin addSubview:weakSelf.receiveView];
            
            [weakSelf creatWhiteboardAction];
            
            [weakSelf.receiveView.finishBtn setTapActionWithBlock:^{
                NSDictionary *msgDic = @{@"classId":@(weakSelf.roomId),@"orderId":weakSelf.orderId,@"type":@(1003)};
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgDic options:0 error:nil];
                
                [weakSelf sendIMMessgeWithJsonData:jsonData];
                
                [weakSelf removeReceiveView];
            }];
        }else{
        
        [MBProgressHUD showMessage:msg];
        weakSelf.receiveView.isSpecial = NO;
        [weakSelf removeReceiveView];
        }
    }];
}

#pragma mark -- TEduBoardDelegate
- (void)onTEBHistroyDataSyncCompleted
{
    //（1）获取白板 UIView
    UIView *boardView = [_boardController getBoardRenderView];
    //（2）设置显示位置和大小
//    boardView.frame = CGRectMake(self.receiveView.liveView.frame.size.width, self.receiveView.liveView.frame.size.height, -self.receiveView.liveView.frame.size.height, -self.receiveView.liveView.frame.size.width);
    
    boardView.frame = CGRectMake(0, 0, self.receiveView.liveView.frame.size.width, self.receiveView.liveView.frame.size.height);
    //（3）添加到父视图中
    [self.receiveView.liveView addSubview:boardView];
    
    self.receiveView.isSpecial = NO;
    [self.receiveView.liveView insertSubview:self.receiveView.finishBtn aboveSubview:boardView];
    
    self.receiveView.finishBtn.enabled = YES;
    self.receiveView.finishBtn.userInteractionEnabled = YES;
}


#pragma mark -- V2TIMSimpleMsgListener
/// 收到 C2C 自定义（信令）消息
- (void)onRecvC2CCustomMessage:(NSString *)msgID  sender:(V2TIMUserInfo *)info customData:(NSData *)data{
    
    NSDictionary *msgDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"msgDicmsgDicmsgDic === %@",msgDic);
    
    OtherModel *model = [OtherModel mj_objectWithKeyValues:msgDic];
    
    if (model.orderId.length > 0) {
    
    self.roomId = [msgDic[@"classId"] intValue];
    self.orderId = msgDic[@"orderId"];
    
    int type = [msgDic[@"type"] intValue];
    
    if (type == 1001 && User.isAnswer) {
        [self addGroupIMAction];
    }else if (type == 1003){
        [self removeReceiveView];
        if (User.isAnswer) {
            [self answerFinishNet];
        }else{
            [self popUpQuestionView];
        }
    }
    }
}

/// 收到 C2C 文本消息
- (void)onRecvC2CTextMessage:(NSString *)msgID  sender:(V2TIMUserInfo *)info text:(NSString *)text{
    
    if (text == nil) {
        return;
    }
    
    NSData *jsonData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *msgDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    OtherModel *model = [OtherModel mj_objectWithKeyValues:msgDic];
    
    if (model.orderId.length > 0) {
        
        self.roomId = [msgDic[@"classId"] intValue];
        self.orderId = msgDic[@"orderId"];
        
        int type = [msgDic[@"type"] intValue];
        
        if (type == 1001 && User.isAnswer) {
            [self addGroupIMAction];
        }else if (type == 1003){
            [self removeReceiveView];
            if (User.isAnswer) {
                [self answerFinishNet];
            }else{
                [self popUpQuestionView];
            }
        }
    }
}



#pragma mark - 发送自定义单聊消息
-(void)sendIMMessgeWithJsonData:(NSData *)jsonData{
    
    [[V2TIMManager sharedInstance] sendC2CCustomMessage:jsonData to:self.userId succ:^{
        NSLog(@"jsonData ====== %@",jsonData);
    } fail:^(int code, NSString *desc) {
        NSLog(@"descdescdescSendMsgFail == %@,codecodecodeSendMsgFail == %d",desc,code);
    }];
}


#pragma mark -- HttpManager
-(void)answerFinishNet{
    if (self.orderId.length <= 0) {
        return;
    }
    NSDate *nowDate = [JLKFUtil getCurrentDate];
    NSTimeInterval dtime = [nowDate timeIntervalSinceDate:self.firstDate]; //单位为秒
     NSString *timeStr = [NSString stringWithFormat:@"%.2f",(CGFloat)dtime/60.0];//时间差除以60得到分钟
    if ([timeStr floatValue] < 1) {
        timeStr = @"1";
    }
    [HttpManager postNotHeadWithURL:answerSuccess_Home andParams:@{@"token":User.token,@"orderId":self.orderId,@"answerDuration":timeStr,@"answerText":@""} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] != MSG_SUCCESS) {
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

-(void)againSendOrderNet{
    if (self.orderId.length <= 0) {
        return;
    }
    [HttpManager postNotHeadWithURL:sendOrder_Home andParams:@{@"token":User.token,@"orderId":self.orderId} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            [MBProgressHUD showMessage:@"已为您所提交的问题重新派单"];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

-(void)chooseAnswerTypeNetWithType:(NSString *)type{
    if (self.orderId.length <= 0) {
        return;
    }
    [HttpManager postNotHeadWithURL:answerType_Home andParams:@{@"token":User.token,@"orderId":self.orderId,@"answerType":type} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
        }else{
//            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

-(void) onReq:(BaseReq*)reqonReq{
    
}

-(void) onResp:(BaseResp*)resp{
    
    if([resp isKindOfClass:[PayResp class]]){//支付结果回调
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        NSString *strTitle;
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                //支付返回结果，实际支付结果需要去自己的服务器端查询
                strMsg = @"支付结果：成功！";
                if (_payDelegate && [_payDelegate respondsToSelector:@selector(WechatPaySuccess)]) {
                    [_payDelegate WechatPaySuccess];
                }
                
                break;
            }
                
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];//给用户看错误码 自己看
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                strMsg = [NSString stringWithFormat:@"支付结果：失败！错误码：%d, 错误原因：%@", resp.errCode,resp.errStr];//不给用户看错误码
                
                if (resp.errCode == -2 &&  [JLKFUtil isEmpty:resp.errStr] ) {
                    strTitle = @"提示"; strMsg = @"您已取消支付";
                }
                break;
            }
                
        }
        
//        if ([_wxDelegate respondsToSelector:@selector(WeChatPaySuccessByCode:)]) {
//            PayResp *resp2 = (PayResp *)resp;
//            [_wxDelegate WeChatPaySuccessByCode:resp2.errCode];
//        }
        if (resp.errCode == WXSuccess) {
            //注释掉 用自自定义的成功提示
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

#pragma mark -- 系统方法

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
