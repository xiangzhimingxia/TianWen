//
//  ChargeViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/1.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ChargeViewController.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "PayModel.h"

@interface ChargeViewController ()<PayResultDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextfield;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIView *submitView;

kAS(NSInteger, stypeNum);
@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

-(void)creatUI{
    self.titleLable.text = @"充值";
    self.view.backgroundColor = MainBackgroundColor;
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 20;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.payDelegate = self;
    __weak typeof(self) weakSelf = self;
    [self.submitView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        [weakSelf requestData];
    }];
}

-(void)requestData{
    self.submitView.userInteractionEnabled = NO;
    NSString *typeStr = @"1";
    if (self.stypeNum == 2) {
        typeStr = @"2";
    }
    [HttpManager postNotHeadWithURL:recharge_Mine andParams:@{@"token":User.token,@"rechargeMoney":self.moneyTextfield.text,@"payType":typeStr} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            PayModel *model = [PayModel mj_objectWithKeyValues:obj[dataKey][@"wxPayMap"]];
            [[WXApiManager sharedManager] wechatPayActionWithData:model];            self.submitView.userInteractionEnabled = YES;
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
            self.submitView.userInteractionEnabled = YES;
        }
    }];
}

-(void)changeFootViewColor{
    if (self.stypeNum > 0 && self.moneyTextfield.text.length > 0 && [self.moneyTextfield.text floatValue] > 0) {
        self.submitView.backgroundColor = KNavColor;
    }else{
        self.submitView.backgroundColor = KNavColorHalf;
    }
}

#pragma Event
- (IBAction)wechatAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.stypeNum = 1;
        self.alipayBtn.selected =  NO;
    }else{
        self.stypeNum = 0;
    }
    [self changeFootViewColor];
}
- (IBAction)alipayAvtion:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.stypeNum = 2;
        self.wechatBtn.selected =  NO;
    }else{
        self.stypeNum = 0;
    }
    [self changeFootViewColor];
}
- (IBAction)moneyEditChange:(UITextField *)sender {
    [self changeFootViewColor];
}

#pragma mark -- PayResultDelegate
-(void)WechatPaySuccess{
    [MBProgressHUD showMessage:@"您已充值成功"];
    self.moneyTextfield.text = nil;
    self.submitView.backgroundColor = KNavColorHalf;
}

@end
