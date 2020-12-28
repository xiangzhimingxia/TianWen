//
//  LoginViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/14.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "IdentityChoiceViewController.h"
#import "OtherModel.h"
#import "WebViewViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    __block int time;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    
    self.titleLable.text = @"登录";
    self.leftButton.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 40;
    
    if (self.isRegister) {
        self.leftButton.hidden = NO;
        self.titleLable.text = @"注册账号";
        [self.firstBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.secondBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    
    [self.firstBtn setBackgroundImage:[UIImage imageByColor:KNavColor] forState:UIControlStateNormal];
    [self.firstBtn setBackgroundImage:[UIImage imageByColor:KNavColorHalf] forState:UIControlStateDisabled];
    
    [self.getCodeBtn setTitleColor:KNavColor forState:UIControlStateNormal];
    [self.getCodeBtn setTitleColor:KNavColorHalf forState:UIControlStateDisabled];
}

-(void)getCodeStr{
    
    time = 60;
    //    self.codeTextField.userInteractionEnabled = YES;
    
    self.getCodeBtn.enabled = NO;
//    self.phoneTextfield.userInteractionEnabled = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(self->time<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                //                CGSize size = LabelSizeWithStr(Localized(@"重新获取验证码"), CGSizeMake(KMainScreenWidth, 30), Attributes(16));
                
                //                self.getCodeWidthConstant.constant = ceil(size.width);
                
                [self.getCodeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                self.getCodeBtn.enabled = YES;
//                self.phoneTextfield.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                self.getCodeBtn.enabled = NO;
                
                NSString *strTime = [NSString stringWithFormat:@"重新发送（%d）",self->time];
                
                //                CGSize size = LabelSizeWithStr(strTime, CGSizeMake(KMainScreenWidth, 30), Attributes(16));
                
                //                self.getCodeWidthConstant.constant = ceil(size.width);
                
                [self.getCodeBtn setTitle:strTime forState:UIControlStateNormal];
                
                
            });
            self->time--;
        }
    });
    dispatch_resume(_timer);
    
}

#pragma mark - Event

- (IBAction)getCodeAction:(id)sender {
    
    if (self.phoneTextfield.text.length < 11) {
        return;
    }
    
    [self.view endEditing:YES];
    [self getCodeStr];
    NSString *typeStr = @"2";
    if (self.isRegister) {
        typeStr = @"1";
    }
    [HttpManager postNotHeadWithURL:SENDMEG_LOGIN andParams:@{@"mobile":self.phoneTextfield.text,@"type":typeStr} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
//            NSLog(@"SMS ========= %@",obj);
            [MBProgressHUD showMessage:obj[dataKey][@"code"]];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}
- (IBAction)phoneChange:(UITextField *)sender {
    self.getCodeBtn.enabled = sender.text.length >= 11 ? YES : NO;
    [self canEnableLogin];
}
- (IBAction)codeChange:(UITextField *)sender {
    [self canEnableLogin];
}
- (IBAction)firstAction:(id)sender {
    [self.view endEditing:YES];
    
    NSString *urlStr = USERLOGIN_LOGIN;
    if (self.isRegister) {
        urlStr = REGiSTERUSER_LOGIN;
    }
    
    [HttpManager postNotHeadWithURL:urlStr andParams:@{@"mobile":self.phoneTextfield.text,@"code":self.codeTextfield.text} returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue]==MSG_SUCCESS) {
            
            OtherModel *model = [OtherModel mj_objectWithKeyValues:obj[dataKey]];
            if (model.answerToken.length > 0) {
                User.isAnswer = YES;
                User.userId = obj[dataKey][@"answerUserId"];
                User.token = obj[dataKey][@"answerToken"];
                User.userIdentity = obj[dataKey][@"isIdentity"];
                [User updateLocalUser];
            }else{
                User.isAnswer = NO;
                User.userId = obj[dataKey][@"userId"];
                User.token = obj[dataKey][@"token"];
                User.userIdentity = obj[dataKey][@"isIdentity"];
                [User updateLocalUser];
            }
            
            if (self.isRegister) {
                IdentityChoiceViewController *identityVC = [IdentityChoiceViewController new];
                [self.navigationController pushViewController:identityVC animated:YES];
            }else{
                if ([obj[dataKey][@"isIdentity"] integerValue] > 0) {
                    User.isLogin = YES;
                    [User updateLocalUser];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate initRootViewController];
                }else{
                    IdentityChoiceViewController *identityVC = [IdentityChoiceViewController new];
                    [self.navigationController pushViewController:identityVC animated:YES];
                }
            }
            
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
    
}
- (IBAction)secondAction:(id)sender {
    if (self.isRegister) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        LoginViewController *vc = [LoginViewController new];
        vc.isRegister = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)canEnableLogin{
    
    if (self.phoneTextfield.text.length >= 11 &&  self.codeTextfield.text.length >= 6 ) {
        self.firstBtn.enabled = YES;
    }else{
        self.firstBtn.enabled = NO;
    }
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTextfield) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
        
    }
    if (textField == self.codeTextfield) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
//    if (textField == self.passwordTextField) {
//        if (string.length == 0) return YES;
//
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 16) {
//            return NO;
//        }
//    }
    return YES;
}

- (IBAction)protocolAction:(id)sender {
    WebViewViewController *vc = [WebViewViewController new];
    vc.type = 4;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
