//
//  QuestionDetailsViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/3.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "QuestionDetailsViewController.h"
#import "OrderOneTableCell.h"
#import "AskVoiceTableCell.h"
#import "OrderTwoTableCell.h"
#import "OrderPictureTableCell.h"
#import "ReceiveLiveView.h"
#import "OtherModel.h"
//#import "OrderDetailsModel.h"

#import "TXLiteAVSDK_TRTC/TRTCCloud.h"
#import "TRTCCalling.h"
#import "GenerateTestUserSig.h"

#import <AVFoundation/AVFoundation.h>

@interface QuestionDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,TRTCCallingDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ReceiveLiveView *receiveView;

kUI(UIButton, answerBtn);
kUI(OrderListModel, detailsModel);
kUI(NSMutableArray, imgMutArr);
kUI(NSMutableArray, recordMutArr);

@end

@implementation QuestionDetailsViewController

-(NSMutableArray *)recordMutArr{
    if (!_recordMutArr) {
        _recordMutArr = [NSMutableArray new];
    }
    return _recordMutArr;
}
-(NSMutableArray *)imgMutArr{
    if (!_imgMutArr) {
        _imgMutArr = [NSMutableArray new];
    }
    return _imgMutArr;
}
-(OrderListModel *)detailsModel{
    if (!_detailsModel) {
        _detailsModel = [OrderListModel new];
    }
    return _detailsModel;
}
-(ReceiveLiveView *)receiveView{
    if (!_receiveView) {
        _receiveView = [[[NSBundle mainBundle]loadNibNamed:@"ReceiveLiveView" owner:self options:nil] lastObject];
        _receiveView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight + SafeAreaBottomHeight);
        [self addSubViewTapAction];
    }
    return _receiveView;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:TXLiveDelegateChange object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self requestData];
}

-(void)creatUI{

    self.titleLable.text = @"订单详情";    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = MainBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0,*)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderOneTableCell" bundle:nil] forCellReuseIdentifier:@"OrderOneTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AskVoiceTableCell" bundle:nil] forCellReuseIdentifier:@"AskVoiceTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderTwoTableCell" bundle:nil] forCellReuseIdentifier:@"OrderTwoTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderPictureTableCell" bundle:nil] forCellReuseIdentifier:@"OrderPictureTableCell"];
    
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 150)];
    footView.backgroundColor = MainBackgroundColor;
    
    self.answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.answerBtn setTitle:@"解答" forState:UIControlStateNormal];
    [self.answerBtn setFont:[UIFont systemFontOfSize:18]];
    [self.answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.answerBtn.backgroundColor = KNavColor;
    self.answerBtn.frame = CGRectMake(35, 50, KMainScreenWidth - 35*2, 50);
    self.answerBtn.clipsToBounds = YES;
    self.answerBtn.layer.cornerRadius = 25;
    self.answerBtn.userInteractionEnabled = NO;
    [footView addSubview:self.answerBtn];
    
    self.tableView.tableFooterView = footView;
    
    __weak typeof(self) weakSelf = self;
    [self.answerBtn setTapActionWithBlock:^{
        
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
        
        [weakSelf answerReceiveOrder];
    }];
    
}

-(void)startIMAnswerAction{
    
    // 监听回调
    [[TRTCCalling shareInstance] addDelegate:self];
    
    self.receiveView.describeLb.text = @"正在等待对方接受邀请…";
    self.receiveView.describeLb.hidden = NO;
//    [self.receiveView.holdImg sd_setImageWithURL:[NSURL URLWithString:self.detailsModel.headPic]];
//    [self.receiveView.headBackImg sd_setImageWithURL:[NSURL URLWithString:self.detailsModel.headPic]];
    self.receiveView.nameLb.text = self.detailsModel.questionName;
    [self.receiveView.finishBtn setBackgroundColor:JColorFromRGB(0xD94850)];
    [self.receiveView.finishBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.receiveView.answerView.hidden = YES;
    self.receiveView.finishBtn.hidden = NO;
    self.receiveView.infoView.hidden = NO;
    
    self.receiveView.finishBtn.userInteractionEnabled = YES;
    self.receiveView.myVideoView.hidden = YES;
    self.receiveView.chooseView.hidden = YES;
    
    [self getUserInfo:self.detailsModel.userId];
    
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [keyWin addSubview:self.receiveView];
    
    
    //20201220105632100001
    // 发起语音通话
    [[TRTCCalling shareInstance] call:self.detailsModel.userId type:CallType_Audio];
    
    NSDictionary *msgDic = @{@"classId":@([self.detailsModel.roomId intValue]),@"orderId":self.detailsModel.orderId,@"type":@(1002)};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgDic options:0 error:nil];
    
    [self sendIMMessgeWithJsonData:jsonData];
    
}

-(void)addSubViewTapAction{
    
    __weak typeof(self) weakSelf = self;
    [self.receiveView.finishBtn setTapActionWithBlock:^{
        // 挂断
        [[TRTCCalling shareInstance] hangup];
        [weakSelf removeReceiveView];
        [weakSelf cancelReceiveOrder];
    }];
}

-(void)requestData{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager getWithURL:orderDetails_Home andParams:@{@"orderId":self.orderId} returnBlcok:^(NSError *error, id obj) {
//        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.detailsModel = [OrderListModel mj_objectWithKeyValues:obj[dataKey][@"orderDetails"]];
            [self sortData];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
    
}

-(void)sortData{
    for (NSInteger i = 0; i<self.detailsModel.orderFileList.count; i++) {
        UploadModel *model = self.detailsModel.orderFileList[i];
        if ([model.fileType integerValue] == 1) {
            [self.imgMutArr addObject:model];
        }else if ([model.fileType integerValue] == 2){
            [self.recordMutArr addObject:model];
        }
    }
    [self.tableView reloadData];
    self.answerBtn.userInteractionEnabled = YES;
}

#pragma mark - TRTCCallingDelegate

// 观看对方的画面
// 由于 A 打开了摄像头，B 接受通话后会收到 onUserVideoAvailable(A, true) 回调
//- (void)onUserVideoAvailable:(NSString *)uid available:(BOOL)available {
//    if (available) {
//        self.receiveView.headBackImg.hidden = YES;
//        
//        [[TRTCCalling shareInstance] startRemoteView:uid view:self.receiveView.liveView]; // 就可以看到对方的画面了
//    } else {
//        [[TRTCCalling shareInstance] stopRemoteView:uid]; // 停止渲染画面
//    }
//}

//用户进入通话回调
-(void)onUserEnter:(NSString *)uid{
    self.receiveView.describeLb.hidden = YES;
//    [self.receiveView.finishBtn setBackgroundColor:KNavColor];
//    [self.receiveView.finishBtn setTitle:@"回答完毕" forState:UIControlStateNormal];
    
//    self.receiveView.infoView.hidden = YES;
//    self.receiveView.myVideoView.hidden = NO;
//    //打开自己的摄像头
//    [[TRTCCalling shareInstance] openCamera:true view:self.receiveView.myVideoView];
}

-(void)onNoResp:(NSString *)uid{
    [MBProgressHUD showMessage:@"暂时无人接听，请稍后重试"];
    [self removeReceiveView];
    [self cancelReceiveOrder];
}

-(void)onCallEnd{
    [self removeReceiveView];
}


-(void)removeReceiveView{
    
    NSDictionary *msgDic = @{@"classId":@([self.detailsModel.roomId intValue]),@"orderId":self.detailsModel.orderId,@"type":@(1002)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TXLiveDelegateChange object:msgDic];
    [self.receiveView removeFromSuperview];
    self.receiveView = nil;
}

-(void)onReject:(NSString *)uid{
    [MBProgressHUD showMessage:@"对方已拒绝通信"];
    [self removeReceiveView];
    [self cancelReceiveOrder];
}

-(void)onLineBusy:(NSString *)uid{
    [MBProgressHUD showMessage:@"对方通信正忙，请稍后重试"];
    [self removeReceiveView];
    [self cancelReceiveOrder];
}

//SDK 不可恢复的错误回调
-(void)onError:(int)code msg:(NSString *)msg{
    [MBProgressHUD showMessage:msg];
    [self removeReceiveView];
    [self cancelReceiveOrder];
}

#pragma mark - 发送自定义单聊消息
-(void)sendIMMessgeWithJsonData:(NSData *)jsonData{
    
    [[V2TIMManager sharedInstance] sendC2CCustomMessage:jsonData to:self.detailsModel.userId succ:^{
        NSLog(@"jsonData ====== %@",jsonData);
    } fail:^(int code, NSString *desc) {
        NSLog(@"descdescdescSendMsgFail == %@,codecodecodeSendMsgFail == %d",desc,code);
    }];
}

#pragma mark -- HttpManager
-(void)answerReceiveOrder{
    self.answerBtn.enabled = NO;
    self.answerBtn.userInteractionEnabled = NO;
    [HttpManager postNotHeadWithURL:meetOrder_Home andParams:@{@"token":User.token,@"orderId":self.orderId} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            [self startIMAnswerAction];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
        self.answerBtn.enabled = YES;
        self.answerBtn.userInteractionEnabled = YES;
    }];
}
-(void)cancelReceiveOrder{
    self.receiveView.finishBtn.enabled = NO;
    self.receiveView.finishBtn.userInteractionEnabled = NO;
    [HttpManager postNotHeadWithURL:userCannelOrder_Home andParams:@{@"token":User.token,@"orderId":self.orderId} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
        self.receiveView.finishBtn.enabled = YES;
        self.receiveView.finishBtn.userInteractionEnabled = YES;
    }];
}

#pragma  tableView -- Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (self.imgMutArr.count%3 == 0) {
            return 1 + self.recordMutArr.count + self.imgMutArr.count/3;
        }else{
            return 1 + self.recordMutArr.count + self.imgMutArr.count/3 + 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        OrderOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderOneTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        [cell refreshUI:self.detailsModel];
        return cell;
    }else{
        if (indexPath.row == 0) {
            OrderTwoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoTableCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = MainBackgroundColor;
            cell.textLb.text = self.detailsModel.describe;
            return cell;
        }else if (indexPath.row >= 1 + self.recordMutArr.count){
            OrderPictureTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPictureTableCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.secondImg.hidden = NO;
            cell.threeImg.hidden = NO;
            [cell.firstImg sd_setImageWithURL:[NSURL URLWithString:[self.imgMutArr[(indexPath.row - 1 - self.recordMutArr.count)*3] fileUrl]]];
            if (self.imgMutArr.count > (indexPath.row - 1 - self.recordMutArr.count)*3 + 1) {
                [cell.secondImg sd_setImageWithURL:[NSURL URLWithString:[self.imgMutArr[(indexPath.row - 1 - self.recordMutArr.count)*3 + 1] fileUrl]]];
            }
            if (self.imgMutArr.count > (indexPath.row - 1 - self.recordMutArr.count)*3 + 2) {
                [cell.threeImg sd_setImageWithURL:[NSURL URLWithString:[self.imgMutArr[(indexPath.row - 1 - self.recordMutArr.count)*3 + 2] fileUrl]]];
            }
            
            if (self.imgMutArr.count%3 == 0) {
                
            }else if (self.imgMutArr.count%3 == 1){
                cell.secondImg.hidden = YES;
                cell.threeImg.hidden = YES;
            }else if (self.imgMutArr.count%3 == 2){
                cell.threeImg.hidden = YES;
            }
            
            return cell;
        } else{
            AskVoiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AskVoiceTableCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = MainBackgroundColor;
            cell.backView.backgroundColor = [UIColor whiteColor];
            cell.toLeftBackViewWidthConstant.constant = 15;
            [cell refreshUI:self.recordMutArr[indexPath.row - 1]];
            return cell;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==  0) {
        return 170;
    }else{
        if (indexPath.row == 0) {
            if (self.detailsModel.describe.length > 0) {
                return 60 + [self.detailsModel.describe heightForFont:[UIFont systemFontOfSize:15] width:KMainScreenWidth - 30*2];
            }else{
                return 60;
            }
        }else if (indexPath.row >= 1 + self.recordMutArr.count){
            return 85;
        }else{
            return 42;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


-(void)getUserInfo:(NSString *)uid{
    [HttpManager getWithURL:userHeadPic_Mine andParams:@{@"userId":uid} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            OtherModel *model = [OtherModel mj_objectWithKeyValues:obj[dataKey]];
            if (model.userHeadPic.length > 0) {
                [self.receiveView.holdImg sd_setImageWithURL:[NSURL URLWithString:model.userHeadPic]];
                [self.receiveView.headBackImg sd_setImageWithURL:[NSURL URLWithString:model.userHeadPic]];
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

//-(void)creatFrostedGlassActionWithInView:(UIView *)backView{
//    //创建毛玻璃
//    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//
//    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
//
//    effe.frame = CGRectMake(0, 0, backView.frame.size.width,backView.frame.size.height);
//
//    //                effe.layer.masksToBounds = YES;
//    //
//    //                effe.layer.cornerRadius = 5;
//
//    effe.alpha = 0.5;
//
//    [backView addSubview:effe];
//}

@end
