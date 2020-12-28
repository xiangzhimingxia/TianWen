//
//  ChargeViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/1.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "ChargeViewController.h"

@interface ChargeViewController ()
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

@end
