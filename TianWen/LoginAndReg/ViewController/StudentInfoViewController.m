//
//  StudentInfoViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/15.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentInfoViewController.h"
#import "CountryPickerView.h"
#import "CHImagePicker.h"
#import "CZHAddressPickerView.h"
#import "TeacherInfoModel.h"
#import "AppDelegate.h"
#import "BasicModel.h"

@interface StudentInfoViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kmainHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boomBtnToHeightConstant;
@property (weak, nonatomic) IBOutlet UIView *uploadHeaderView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *KbackVIewWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UITextField *schoolTextfield;
@property (weak, nonatomic) IBOutlet UILabel *gradeLb;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UILabel *holdLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIView *submitView;

kUI(UIImage, headImg);
kUI(TeacherInfoModel, infoModel);
//kUI(FootChooseView, footChooseView);
//kUI(NSArray, qualificationArr);

kUI(NSArray, gradeArr);

@end

@implementation StudentInfoViewController

-(NSArray *)gradeArr{
    if (!_gradeArr) {
        _gradeArr = [NSArray new];
    }
    return _gradeArr;
}
//-(FootChooseView *)footChooseView{
//    if (!_footChooseView) {
//        //        _footChooseView = [[[NSBundle mainBundle]loadNibNamed:@"FootChooseView" owner:self options:nil] lastObject];
//        _footChooseView = [FootChooseView new];
//        _footChooseView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
//        _footChooseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
//        _footChooseView.delegate = self;
//        //        [_shareView.cancelBtn addTarget:self action:@selector(shareCancel) forControlEvents:UIControlEventTouchUpInside];
//        UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
//        [keyWin addSubview:_footChooseView];
//        _footChooseView.hidden = YES;
//    }
//    return _footChooseView;
//}
-(TeacherInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [TeacherInfoModel new];
    }
    return _infoModel;
}
//-(NSArray *)qualificationArr{
//    if (!_qualificationArr) {
//        _qualificationArr = @[@"初级",@"中级",@"高级"];
//    }
//    return _qualificationArr;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    self.infoModel.gender = @"1";
    [self getBasicData];
    [self callbackModule];
}

-(void)creatUI{
    
    self.KbackVIewWidthConstant.constant = KMainScreenWidth;
    self.toTopHeightConstant.constant = SafeAreaTopHeight;
    
    self.titleLable.text = @"学生信息";
    
    if (self.isLogin) {
        self.titleLable.text = @"学生身份";
        self.kmainHeightConstant.constant =  678 - 104;
        self.boomBtnToHeightConstant.constant = 169 - 104;
        self.uploadHeaderView.hidden = YES;
    }
}

-(void)callbackModule{
    __weak typeof(self) weakSelf = self;
    [self.addressView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        
        [CZHAddressPickerView areaPickerViewWithProvince:weakSelf.infoModel.province city:weakSelf.infoModel.city area:weakSelf.infoModel.area areaBlock:^(NSString *province, NSString *city, NSString *area) {
            weakSelf.infoModel.province = province;
            weakSelf.infoModel.city = city;
            weakSelf.infoModel.area = area;
            
            weakSelf.addressLb.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
            [weakSelf changeFootViewColor];
        }];
        
    }];
    
    [self.gradeView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        
        CountryPickerView *myCountryPickerView = [[CountryPickerView alloc]initWithFrame:weakSelf.view.bounds];
        myCountryPickerView.titleLabel.text = @"选择年级";
        NSMutableArray *mutArr = [NSMutableArray new];
        for (NSInteger i = 0; i<weakSelf.gradeArr.count; i++) {
            BasicModel *model = weakSelf.gradeArr[i];
            [mutArr addObject:model.gradeName];
        }
        myCountryPickerView.adressDataArr = [mutArr copy];
        [myCountryPickerView showAddressPickView];
        
        myCountryPickerView.block = ^(NSString *province, NSInteger provinceNum) {
            weakSelf.gradeLb.text = province;
            if (weakSelf.gradeArr.count > provinceNum) {
                BasicModel *model = weakSelf.gradeArr[provinceNum];
                weakSelf.infoModel.gradeId = model.gradeId;
            }
        };
        
    }];
    
    
    if (!self.isLogin) {
        
        [self.headImgView setTapActionWithBlock:^{
            [weakSelf.view endEditing:YES];
            [[CHImagePicker shareInstance] showWithController:self pushController:self finish:^(UIImage *image) {
                //            NSLog(@"image=%@",image);
                
                //压缩图片
                //            image = [image imageByResizeToSize:CGSizeMake(104, 104)];
                
                weakSelf.headImg = image;
                [weakSelf.headImgView setImage:image];
                [weakSelf changeFootViewColor];
                
            } cancel:^(UIImage *image) {
            } animated:YES];
            
        }];
        
    }
    
    [self.submitView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        if (weakSelf.isLogin) {
            [weakSelf submitAction];
        }else{
            [weakSelf updateHeadPic];
        }
        
    }];
    
}

-(void)getPersonInfoData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpManager getWithURL:userInfo_Mine andParams:@{@"token":User.token} returnBlcok:^(NSError *error, id obj) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            
            self.infoModel = [TeacherInfoModel mj_objectWithKeyValues:obj[dataKey][@"userInfo"]];
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.headPic] placeholderImage:[UIImage imageNamed:@"pic_a"]];
            self.nameTextfield.text = self.infoModel.nickName;
            self.addressLb.text = [NSString stringWithFormat:@"%@ %@ %@",self.infoModel.province,self.infoModel.city,self.infoModel.area];
            self.schoolTextfield.text= self.infoModel.school;
            self.gradeLb.text = self.infoModel.gradeName;
            if ([self.infoModel.gender integerValue] == 2) {
                self.manBtn.selected = NO;
                self.womanBtn.selected = YES;
            }else{
                self.manBtn.selected = YES;
                self.womanBtn.selected = NO;
            }
            self.describeTextView.text = self.infoModel.remarks;
            if (self.infoModel.remarks.length > 0) {
                self.holdLb.hidden = YES;
            }
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
    
}

-(void)getBasicData{
    
    [HttpManager getWithURL:grade_LOGIN andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.gradeArr = [BasicModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"gradeList"]];
            if (self.gradeArr > 0 && self.isLogin) {
                BasicModel *model = [self.gradeArr firstObject];
                self.infoModel.gradeId = model.gradeId;
                self.gradeLb.text = model.gradeName;
            }
        }
    }];
    
    if (!self.isLogin) {
        [self getPersonInfoData];
    }
    
}

-(void)updateHeadPic{
    
    [HttpManager postWithURL1:UPLOADFILE andParams:nil imageFiles:@[self.headImg] withFilesName:@"file" returnBlcok:^(NSError *error, id obj) {
        if ([obj[@"code"] integerValue] == 0) {
            self.infoModel.headPic = obj[@"data"][@"src"];
            [self submitAction];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showMessage:@"请求失败，请重试"];
        }
    }];
    
}

-(void)submitAction{
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *paramsMutDic = [NSMutableDictionary new];
    
    NSDictionary *params = @{@"token":User.token,@"nickName":self.nameTextfield.text,@"realName":self.nameTextfield.text,@"gradeId":self.infoModel.gradeId,@"gender":self.infoModel.gender,@"province":self.infoModel.province,@"city":self.infoModel.city,@"area":self.infoModel.area,@"school":self.schoolTextfield.text};
    
    paramsMutDic = [params mutableCopy];
    
    if (self.describeTextView.text.length > 0) {
        [paramsMutDic setValue:self.describeTextView.text forKey:@"remarks"];
    }
    
    if (self.isLogin) {
        [paramsMutDic setValue:@"1" forKey:@"userIdentity"];
    }else{
        [paramsMutDic setValue:self.infoModel.headPic forKey:@"headPic"];
    }
    
    [HttpManager postNotHeadWithURL:FILLUSERINFO_LOGIN andParams:[paramsMutDic copy] returnBlcok:^(NSError *error, id obj) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            if (weakSelf.isLogin) {
                
                User.isLogin = YES;
                [User updateLocalUser];
                [(AppDelegate *)[UIApplication sharedApplication].delegate initRootViewController];
            }else{
//                [MBProgressHUD showMessage:@"保存成功"];                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
}

#pragma mark -- Event

-(void)changeFootViewColor{
    
    if (self.nameTextfield.text.length > 0 && self.addressLb.text.length > 0 && self.schoolTextfield.text.length > 0 ) {
        if (!self.isLogin && self.headImg == nil && self.infoModel.headPic.length <= 0) {
            self.submitView.userInteractionEnabled = NO;
            self.submitView.backgroundColor = KNavColorHalf;
        }else{
            self.submitView.backgroundColor = KNavColor;
            self.submitView.userInteractionEnabled = YES;
        }
    }else{
        self.submitView.userInteractionEnabled = NO;
        self.submitView.backgroundColor = KNavColorHalf;
    }
}

- (IBAction)nameChange:(id)sender {
    [self changeFootViewColor];
}

- (IBAction)schoolChange:(id)sender {
    [self changeFootViewColor];
}

- (IBAction)manAction:(UIButton *)sender {
    sender.selected =  !sender.selected;
    self.womanBtn.selected = !sender.selected;
    self.infoModel.gender = sender.selected ? @"1" : @"2";
}
- (IBAction)womanAction:(UIButton *)sender {
    sender.selected =  !sender.selected;
    self.manBtn.selected = !sender.selected;
    self.infoModel.gender = sender.selected ? @"2" : @"1";
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.holdLb.hidden = textView.text.length > 0 ? YES : NO;
    [self changeFootViewColor];
}

//#pragma mark - FootChooseDelegate
//-(void)getBackText:(NSString *)text AndIsCancel:(BOOL)isCancel AndType:(NSInteger)typeNum{
//    if (!isCancel) {
//        if (typeNum == 1) {
//            self.qualificationLb.text = text;
//        }else if (typeNum == 2){
//            self.mandarinLb.text = text;
//        }
//    }
//    self.footChooseView.hidden = YES;
//}

@end
