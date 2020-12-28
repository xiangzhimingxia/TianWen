//
//  TaacherInfoApplyViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/2.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "TaacherInfoApplyViewController.h"
#import "CountryPickerView.h"
#import "CHImagePicker.h"
#import "CZHAddressPickerView.h"
#import "TeacherInfoModel.h"
#import "FootChooseView.h"
#import "AppDelegate.h"
#import "BasicModel.h"
#import "ApplyWaitView.h"
#import "ApplyRefuseView.h"

@interface TaacherInfoApplyViewController ()<UITextViewDelegate,FootChooseDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kmainHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boomBtnToHeightConstant;
@property (weak, nonatomic) IBOutlet UIView *uploadHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *submitLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *KbackVIewWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeightConstant;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UIView *subjectsView;
@property (weak, nonatomic) IBOutlet UIView *qualificationView;
@property (weak, nonatomic) IBOutlet UILabel *qualificationLb;
@property (weak, nonatomic) IBOutlet UIView *mandarinView;
@property (weak, nonatomic) IBOutlet UILabel *mandarinLb;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UITextField *schoolTextfield;
@property (weak, nonatomic) IBOutlet UILabel *gradeLb;
@property (weak, nonatomic) IBOutlet UILabel *subjectsLb;
@property (weak, nonatomic) IBOutlet UITextField *fixYearsTextfield;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UILabel *holdLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UILabel *describeHoldLb;

kUI(UIImage, headImg);
kUI(TeacherInfoModel, infoModel);
kUI(FootChooseView, footChooseView);

kUI(NSArray, gradeArr);
kUI(NSArray, subjectArr);
kUI(NSArray, qualificationsArr);
kUI(NSArray, mandarinArr);

kUI(ApplyWaitView, waitView);
kUI(ApplyRefuseView, refuseView);

@end

@implementation TaacherInfoApplyViewController

-(ApplyWaitView *)waitView{
    if (!_waitView) {
        _waitView = [[[NSBundle mainBundle]loadNibNamed:@"ApplyWaitView" owner:self options:nil] lastObject];
        _waitView.frame = CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight);
    }
    return _waitView;
}
-(ApplyRefuseView *)refuseView{
    if (!_refuseView) {
        _refuseView = [[[NSBundle mainBundle]loadNibNamed:@"ApplyRefuseView" owner:self options:nil] lastObject];
        _refuseView.frame = CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight);
    }
    return _refuseView;
}
-(NSArray *)mandarinArr{
    if (!_mandarinArr) {
        _mandarinArr = [NSArray new];
    }
    return _mandarinArr;
}
-(NSArray *)qualificationsArr{
    if (!_qualificationsArr) {
        _qualificationsArr = [NSArray new];
    }
    return _qualificationsArr;
}
-(NSArray *)subjectArr{
    if (!_subjectArr) {
        _subjectArr = [NSArray new];
    }
    return _subjectArr;
}
-(NSArray *)gradeArr{
    if (!_gradeArr) {
        _gradeArr = [NSArray new];
    }
    return _gradeArr;
}
-(FootChooseView *)footChooseView{
    if (!_footChooseView) {
//        _footChooseView = [[[NSBundle mainBundle]loadNibNamed:@"FootChooseView" owner:self options:nil] lastObject];
        _footChooseView = [FootChooseView new];
        _footChooseView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
        _footChooseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        _footChooseView.delegate = self;
        //        [_shareView.cancelBtn addTarget:self action:@selector(shareCancel) forControlEvents:UIControlEventTouchUpInside];
        UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
        [keyWin addSubview:_footChooseView];
        _footChooseView.hidden = YES;
    }
    return _footChooseView;
}
-(TeacherInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [TeacherInfoModel new];
    }
    return _infoModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)creatUI{
    
    self.KbackVIewWidthConstant.constant = KMainScreenWidth;
    self.toTopHeightConstant.constant = SafeAreaTopHeight;
    
    if (!self.isLogin && !self.isAnswerInfo && !self.isTeacherInfo) {
        
    if ([self.auditsStatus integerValue] == 0) {
        self.titleLable.text = @"申请详情";
        [self.view addSubview:self.waitView];
        return;
    }else if ([self.auditsStatus integerValue] == 1){
        self.titleLable.text = @"申请详情";
        self.waitView.stateLb.text = @"您的申请已通过，请重新登录至解答人端";
        [self.view addSubview:self.waitView];
        return;
    }else if ([self.auditsStatus integerValue] == 2){
        self.titleLable.text = @"申请详情";
        [self.view addSubview:self.refuseView];
        __weak typeof(self) weakSelf = self;
        [self.refuseView.applyBtn setTapActionWithBlock:^{
            TaacherInfoApplyViewController *vc = [TaacherInfoApplyViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        return;
    }
    }
    
    self.titleLable.text = @"申请成为解答人";
    
    if (self.isTeacherInfo) {
        self.titleLable.text = @"教师身份";
        self.kmainHeightConstant.constant =  936 - 104;
        self.boomBtnToHeightConstant.constant = 169 - 104;
        self.uploadHeaderView.hidden = YES;
        self.submitLb.text = @"确定";
        self.describeHoldLb.text = @"备注：";
    }
    
    if (self.isAnswerInfo) {
        self.titleLable.text = @"教师信息";
        self.submitLb.text = @"确定";
        self.describeHoldLb.text = @"备注：";
    }
    
    self.infoModel.gender = @"1";
    [self getBasicData];
    [self callbackModule];
    if (self.isAnswerInfo) {
        [self getPersonInfoData];
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
        myCountryPickerView.titleLabel.text = @"选择教授年级";
        
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
    
    [self.subjectsView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        
        CountryPickerView *myCountryPickerView = [[CountryPickerView alloc]initWithFrame:weakSelf.view.bounds];
        myCountryPickerView.titleLabel.text = @"选择擅长科目";
        
        NSMutableArray *mutArr = [NSMutableArray new];
        for (NSInteger i = 0; i<weakSelf.subjectArr.count; i++) {
            BasicModel *model = weakSelf.subjectArr[i];
            [mutArr addObject:model.subjectName];
        }
        myCountryPickerView.adressDataArr = mutArr;
        [myCountryPickerView showAddressPickView];
        
        myCountryPickerView.block = ^(NSString *province, NSInteger provinceNum) {
            weakSelf.subjectsLb.text = province;
            if (weakSelf.subjectArr.count > provinceNum) {
                BasicModel *model = weakSelf.subjectArr[provinceNum];
                weakSelf.infoModel.subjectId = model.subjectId;
            }
        };
        
    }];
    
    [self.qualificationView setTapActionWithBlock:^{
       [weakSelf.view endEditing:YES];
        
        NSMutableArray *sortArr = [NSMutableArray array];
        for (NSInteger i = 0; i<weakSelf.qualificationsArr.count; i++) {
            BasicModel *model = weakSelf.qualificationsArr[i];
            [sortArr addObject:model.qualificationsName];
        }
        
        weakSelf.footChooseView.dataArr = [sortArr copy];
        weakSelf.footChooseView.typeNum = 1;
        weakSelf.footChooseView.hidden = NO;
        
    }];
    
    [self.mandarinView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        
        NSMutableArray *sortArr = [NSMutableArray array];
        for (NSInteger i = 0; i<weakSelf.mandarinArr.count; i++) {
            BasicModel *model = weakSelf.mandarinArr[i];
            [sortArr addObject:model.mandarinName];
        }
        
        weakSelf.footChooseView.dataArr = [sortArr copy];
        weakSelf.footChooseView.typeNum = 2;
        weakSelf.footChooseView.hidden = NO;
        
    }];
    
    
    if (!self.isTeacherInfo) {
        
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
        
        [weakSelf.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        
        if (weakSelf.isLogin) {
            [weakSelf submitAction];
        }else if(weakSelf.isTeacherInfo){
            [weakSelf submitAction];
        }else if(weakSelf.isAnswerInfo){
            [weakSelf updateHeadPic];
        }else{
            [weakSelf updateHeadPic];
        }
        
    }];
    
}

-(void)getBasicData{
    
    [HttpManager getWithURL:grade_LOGIN andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.gradeArr = [BasicModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"gradeList"]];
            if (self.gradeArr > 0 && !self.isAnswerInfo) {
                BasicModel *model = [self.gradeArr firstObject];
                self.infoModel.gradeId = model.gradeId;
                self.gradeLb.text = model.gradeName;
            }
        }
    }];
    
    [HttpManager getWithURL:subject_LOGIN andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.subjectArr = [BasicModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"subjectList"]];
            if (self.subjectArr > 0 && !self.isAnswerInfo) {
                BasicModel *model = [self.subjectArr firstObject];
                self.infoModel.subjectId = model.subjectId;
                self.subjectsLb.text = model.subjectName;
            }
        }
    }];
    
    [HttpManager getWithURL:qualifications_LOGIN andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.qualificationsArr = [BasicModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"qualificationsList"]];
            if (self.qualificationsArr > 0 && !self.isAnswerInfo) {
                BasicModel *model = [self.qualificationsArr firstObject];
                self.infoModel.qualificationsId = model.qualificationsId;
                self.qualificationLb.text = model.qualificationsName;
            }
        }
    }];
    
    [HttpManager getWithURL:mandarin_LOGIN andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.mandarinArr = [BasicModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"mandarinList"]];
            if (self.mandarinArr > 0 && !self.isAnswerInfo) {
                BasicModel *model = [self.mandarinArr firstObject];
                self.infoModel.mandarinId = model.mandarinId;
                self.mandarinLb.text = model.mandarinName;
            }
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
            self.subjectsLb.text = self.infoModel.subjectName;
            self.fixYearsTextfield.text = self.infoModel.years;
            self.qualificationLb.text = self.infoModel.qualificationsName;
            self.mandarinLb.text = self.infoModel.mandarinName;
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

-(void)updateHeadPic{
    
    [HttpManager postWithURL1:UPLOADFILE andParams:nil imageFiles:@[self.headImg] withFilesName:@"file" returnBlcok:^(NSError *error, id obj) {
        if ([obj[@"code"] integerValue] == 0) {
            self.infoModel.headPic = obj[@"data"][@"src"];
            if (self.isTeacherInfo || self.isAnswerInfo || self.isLogin) {
                [self submitAction];
            }else{
                [self applyAnswerPersonAction];
            }
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showMessage:@"请求失败，请重试"];
        }
    }];
    
}

-(void)applyAnswerPersonAction{
    
    NSMutableDictionary *paramsMutDic = [NSMutableDictionary new];
    
    NSDictionary *params = @{@"token":User.token,@"nickName":self.nameTextfield.text,@"gradeId":self.infoModel.gradeId,@"gender":self.infoModel.gender,@"province":self.infoModel.province,@"city":self.infoModel.city,@"area":self.infoModel.area,@"school":self.schoolTextfield.text,@"subjectId":self.infoModel.subjectId,@"years":self.fixYearsTextfield.text,@"qualificationsId":self.infoModel.qualificationsId,@"mandarinId":self.infoModel.mandarinId};
    
    paramsMutDic = [params mutableCopy];
    
    if (self.describeTextView.text.length > 0) {
        [paramsMutDic setValue:self.describeTextView.text forKey:@"describe"];
    }
    
    if (self.isLogin || self.isTeacherInfo) {
        [paramsMutDic setValue:@"2" forKey:@"userIdentity"];
    }else{
        [paramsMutDic setValue:self.infoModel.headPic forKey:@"headPic"];
    }
    
    [HttpManager postNotHeadWithURL:applyAnswer_LOGIN andParams:[paramsMutDic copy] returnBlcok:^(NSError *error, id obj) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            
            [MBProgressHUD showMessage:@"已申请解答人"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showMessage:obj[msgKey]];
        }
    }];
    
}

-(void)submitAction{
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *paramsMutDic = [NSMutableDictionary new];
    
    NSDictionary *params = @{@"token":User.token,@"nickName":self.nameTextfield.text,@"realName":self.nameTextfield.text,@"gradeId":self.infoModel.gradeId,@"gender":self.infoModel.gender,@"province":self.infoModel.province,@"city":self.infoModel.city,@"area":self.infoModel.area,@"school":self.schoolTextfield.text,@"subjectId":self.infoModel.subjectId,@"years":self.fixYearsTextfield.text,@"qualificationsId":self.infoModel.qualificationsId,@"mandarinId":self.infoModel.mandarinId};
    
    paramsMutDic = [params mutableCopy];
    
    if (self.describeTextView.text.length > 0) {
        [paramsMutDic setValue:self.describeTextView.text forKey:@"remarks"];
    }
    
    if (self.isLogin || self.isTeacherInfo) {
        [paramsMutDic setValue:@"2" forKey:@"userIdentity"];
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
    
    if (self.nameTextfield.text.length > 0 && self.addressLb.text.length > 0 && self.schoolTextfield.text.length > 0 && self.fixYearsTextfield.text.length > 0) {
        if (!self.isTeacherInfo && self.headImg == nil && self.infoModel.headPic.length <= 0) {
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
- (IBAction)fixYearChange:(id)sender {
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

#pragma mark - FootChooseDelegate
-(void)getBackText:(NSString *)text AndIsCancel:(BOOL)isCancel AndType:(NSInteger)typeNum{
    if (!isCancel) {
        if (typeNum == 1) {
            self.qualificationLb.text = text;
            if (self.qualificationsArr.count > typeNum) {
                self.infoModel.qualificationsId = [self.qualificationsArr[typeNum] qualificationsId];
            }
        }else if (typeNum == 2){
            self.mandarinLb.text = text;
            if (self.mandarinArr.count > typeNum) {
                self.infoModel.mandarinId = [self.mandarinArr[typeNum] mandarinId];
            }
        }
    }
    self.footChooseView.hidden = YES;
}

@end
