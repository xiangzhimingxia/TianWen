//
//  IntegralExchangeViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "IntegralExchangeViewController.h"

@interface IntegralExchangeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UILabel *describeLb;
@property (weak, nonatomic) IBOutlet UILabel *intrgralNumLb;
@property (weak, nonatomic) IBOutlet UITextField *integralTextfield;
@property (weak, nonatomic) IBOutlet UIView *sureView;

@end

@implementation IntegralExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    [self requestData];
}

-(void)creatUI{
    self.titleLable.text = @"积分兑换";
    self.view.backgroundColor = [UIColor whiteColor];
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 20;
    self.intrgralNumLb.text = self.integral;
    __weak typeof(self) weakSelf =  self;
    [self.sureView setTapActionWithBlock:^{
        [weakSelf sureAction];
    }];
}

-(void)sureAction{
    [self.view endEditing:YES];
    
    if (self.integralTextfield.text.length < 0 || [self.integralTextfield.text integerValue] <= 0) {
        return;
    }
    
    self.sureView.userInteractionEnabled = NO;
    [HttpManager postNotHeadWithURL:integral_Mine andParams:@{@"token":User.token,@"integral":self.integralTextfield.text} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            [MBProgressHUD showMessage:@"积分已兑换"];
            
            self.intrgralNumLb.text = [NSString stringWithFormat:@"%ld",[self.intrgralNumLb.text integerValue] - [self.integralTextfield.text integerValue]];
            self.integralTextfield.text = nil;
        }else{
            [MBProgressHUD showMessage:obj[@"message"]];
            self.sureView.userInteractionEnabled = YES;
        }
    }];
}

-(void)requestData{
    [HttpManager getWithURL:integralSet_Mine andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.describeLb.text = [NSString stringWithFormat:@"说明：%@",obj[dataKey][@"integralSet"]];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
