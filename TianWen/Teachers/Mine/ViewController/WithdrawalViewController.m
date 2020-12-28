//
//  WithdrawalViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/11.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "WithdrawalViewController.h"

@interface WithdrawalViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextfield;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UITextView *InstructionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLb;

kAS(NSInteger, stypeNum);

@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

-(void)creatUI{
    self.titleLable.text = @"提现";
    self.view.backgroundColor = MainBackgroundColor;
    self.toTopHeightConstant.constant = SafeAreaTopHeight + 33;
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
        self.bankBtn.selected = NO;
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
        self.bankBtn.selected = NO;
    }else{
        self.stypeNum = 0;
    }
    [self changeFootViewColor];
}
- (IBAction)bankAction:(UIButton *)sender {
    if (sender.selected) {
        self.stypeNum = 3;
        self.alipayBtn.selected =  NO;
        self.wechatBtn.selected = NO;
    }else{
        self.stypeNum = 0;
    }
    [self changeFootViewColor];
}
- (IBAction)moneyEditChange:(UITextField *)sender {
    [self changeFootViewColor];
}

#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.instructionLb.hidden = textView.text.length > 0 ? YES : NO;
}

@end
