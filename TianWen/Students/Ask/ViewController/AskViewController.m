//
//  AskViewController.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/19.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "AskViewController.h"
#import "AskTopView.h"
#import "AskPicTableCell.h"
#import "AskVoiceTableCell.h"
#import "ZZJRecordButton.h"
#import "LVRecordTool.h"
#import "OtherModel.h"
#import "CountryPickerView.h"
#import "CHImagePicker.h"
#import "BasicModel.h"
#import "AskModel.h"
#import "UploadModel.h"
//#import "CXAudioPlayer.h"
#import "lame.h"

@interface AskViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AskTopView *topView;

@property (nonatomic, strong) UIView *sumbitView;

//录音工具类
@property(nonatomic,strong)LVRecordTool * recordTool;

//录音时  提示的相关view
@property(nonatomic,weak)UIImageView * bgView;
@property(nonatomic,weak)UIImageView * stateImageView;
@property(nonatomic,weak)UILabel * textLabel;

kUI(NSMutableArray, recordMutArr);
kUI(NSArray, gradeArr);
kUI(AskModel, askModel);
kUI(NSArray, subjectArr);
kUI(NSMutableArray, imgMutArr);
kUI(NSMutableArray, fileMutArr);

//@property(nonatomic,strong)AVPlayer *player;

@end

@implementation AskViewController

//- (AVPlayer *)player {
//
//    if (_player == nil) {
//        _player = [[AVPlayer alloc] init];
//        _player.volume = 1.0; // 默认最大音量
//    }
//    return _player;
//}
-(NSMutableArray *)fileMutArr{
    if (!_fileMutArr) {
        _fileMutArr = [NSMutableArray new];
    }
    return _fileMutArr;
}
-(NSMutableArray *)imgMutArr{
    if (!_imgMutArr) {
        _imgMutArr = [NSMutableArray new];
    }
    return _imgMutArr;
}
-(NSArray *)subjectArr{
    if (!_subjectArr) {
        _subjectArr = [NSArray new];
    }
    return _subjectArr;
}
-(AskModel *)askModel{
    if (!_askModel) {
        _askModel = [AskModel new];
    }
    return _askModel;
}
-(NSArray *)gradeArr{
    if (!_gradeArr) {
        _gradeArr = [NSArray new];
    }
    return _gradeArr;
}
-(NSMutableArray *)recordMutArr{
    if (!_recordMutArr) {
        _recordMutArr = [NSMutableArray new];
    }
    return _recordMutArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    [self getBasicData];
    [self callbackModule];
}

-(void)creatUI{
    
    self.titleLable.text = @"提问";
    self.leftButton.hidden = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KMainScreenWidth, KMainScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = MainBackgroundColor;
    self.tableView.bounces = NO;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AskPicTableCell" bundle:nil] forCellReuseIdentifier:@"AskPicTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AskVoiceTableCell" bundle:nil] forCellReuseIdentifier:@"AskVoiceTableCell"];
    
    
    self.topView = [[[NSBundle mainBundle]loadNibNamed:@"AskTopView" owner:self options:nil] lastObject];
    self.topView.frame = CGRectMake(0, 0, KMainScreenWidth, 435);
    self.tableView.tableHeaderView = self.topView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 150)];
    footView.backgroundColor = MainBackgroundColor;
    
    self.sumbitView = [[UIView alloc]initWithFrame:CGRectMake(35, 50, KMainScreenWidth - 35*2, 50)];
    self.sumbitView.backgroundColor = KHEXCOLOR(@"49CA6D",0.5);
    self.sumbitView.clipsToBounds = YES;
    self.sumbitView.layer.cornerRadius = 25;
    self.sumbitView.userInteractionEnabled = NO;
    [footView addSubview:self.sumbitView];
    
    UILabel *sumbitLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth - 35*2, 50)];
    sumbitLb.text = @"提交";
    sumbitLb.textColor = [UIColor whiteColor];
    sumbitLb.font = [UIFont systemFontOfSize:18];
    sumbitLb.textAlignment = NSTextAlignmentCenter;
    [self.sumbitView addSubview:sumbitLb];
    
    self.tableView.tableFooterView = footView;
    
    [self.topView.titleTextfield addTarget:self action:@selector(titleTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.topView.describeTextView.delegate = self;
    
    
    self.recordTool = [LVRecordTool sharedRecordTool];
    
    // 录音按钮
    [self.topView.recordButton addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.topView.recordButton addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.recordButton addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
}

-(void)getBasicData{
    
    [HttpManager getWithURL:grade_LOGIN andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.gradeArr = [BasicModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"gradeList"]];
            if (self.gradeArr > 0) {
                BasicModel *model = [self.gradeArr firstObject];
                self.askModel.gradeId = model.gradeId;
                self.topView.gradeLb.text = model.gradeName;
            }
        }
    }];
    
    [HttpManager getWithURL:subject_LOGIN andParams:nil returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            self.subjectArr = [BasicModel mj_objectArrayWithKeyValuesArray:obj[dataKey][@"subjectList"]];
            if (self.subjectArr > 0) {
                BasicModel *model = [self.subjectArr firstObject];
                self.askModel.subjectId = model.subjectId;
                self.topView.subjectLb.text = model.subjectName;
            }
        }
    }];
    
}

-(void)uploadImgFiles{
    if (self.imgMutArr.count > 0) {
    
    for (NSInteger i = 0; i<self.imgMutArr.count; i++) {
        NSArray *imgArr = [NSArray arrayWithObject:self.imgMutArr[i]];
    [HttpManager postWithURL1:UPLOADFILE andParams:nil imageFiles:imgArr withFilesName:@"file" returnBlcok:^(NSError *error, id obj) {
        if ([obj[@"code"] integerValue] == 0) {
            NSDictionary *dic = @{@"fileType":@"1",@"fileUrl":obj[@"data"][@"src"],@"fileSize":@" "};
            [self.fileMutArr addObject:dic];
            
            if (i == self.imgMutArr.count - 1) {
                [self uploadVoiceFiles];
            }
        }else{
            if (i == self.imgMutArr.count - 1) {
                [self uploadVoiceFiles];
            }
        }
        
    }];
    }
    }else{
        [self uploadVoiceFiles];
    }
}

-(void)uploadVoiceFiles{
    if (self.recordMutArr.count > 0) {
        for (NSInteger i = 0; i<self.recordMutArr.count; i++) {
            OtherModel *model = self.recordMutArr[i];
            
            NSString *mp3FilePath = [[[JLKFUtil getCacheDirectory] stringByAppendingPathComponent:[NSString getCurrentTimesAboutTimestamp]] stringByAppendingPathExtension:@"mp3"];                        
            
            if (![JLKFUtil ConvertWavToMp3:self.recordTool.recordFileStr mp3SavePath:mp3FilePath]) {
                break;
            }
            
//            NSURL *localUrlStr = [self audio_PCMtoMP3WithSourceUrl:model.recordLocalURL];
            
        [HttpManager postWithURL3:UPLOADFILE andParams:nil voiceFiles:mp3FilePath withFilesName:@"file" returnBlcok:^(NSError *error, id obj) {
            if ([obj[@"code"] integerValue] == 0) {
                NSDictionary *dic = @{@"fileType":@"2",@"fileUrl":obj[@"data"][@"src"],@"fileSize":model.recordTimeStr};
                [self.fileMutArr addObject:dic];
                
                if (i == self.recordMutArr.count - 1) {
                    [self uploadTextData];
                }
            }else{
                if (i == self.recordMutArr.count - 1) {
                    [self uploadTextData];
                }
            }
            
        }];
        }
    }else{
        [self uploadTextData];
    }
    
}

-(void)uploadTextData{
    
    NSDictionary *params = @{@"token":User.token,@"askTitle":self.topView.titleTextfield.text,@"describe":self.topView.describeTextView.text,@"gradeId":self.askModel.gradeId,@"subjectId":self.askModel.subjectId};
    
    NSMutableDictionary *paramsMutDic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    if (self.fileMutArr.count > 0) {
        [paramsMutDic setObject:[self.fileMutArr copy] forKey:@"orderFile"];
//        [paramsMutDic setValue:[self.fileMutArr copy] forKey:@"orderFile"];
    }
    
    [HttpManager postNotHeadWithURL:addOrder_Home andParams:[paramsMutDic copy] returnBlcok:^(NSError *error, id obj) {
        if ([SuccessInfo integerValue] == MSG_SUCCESS) {
            [self clearView];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showMessage:@"问题已发布"];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showMessage:obj[msgKey]];
            self.sumbitView.userInteractionEnabled = YES;
        }
    }];
    
}

-(void)clearView{
    
    self.topView.titleTextfield.text = nil;
    self.topView.describeTextView.text = nil;
    self.topView.holdLb.hidden = NO;
    
    for (NSInteger i = 0 ; i<self.recordMutArr.count; i++) {
        
        OtherModel *model = self.recordMutArr[i];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (model.recordLocalURL && [fileManager fileExistsAtPath:model.recordLocalStr]) {
            
            [fileManager removeItemAtPath:model.recordLocalStr error:NULL];
        }
        
        if (i == self.recordMutArr.count - 1) {
            [self.recordMutArr removeAllObjects];
        }
    }
    
    [self.imgMutArr removeAllObjects];
//    [self.recordMutArr removeAllObjects];
    
    [self.tableView reloadData];
    self.sumbitView.userInteractionEnabled = NO;
    
    //多线程
//    [NSThread detachNewThreadSelector:@selector(clearRecodFiles:) toTarget:self withObject:[self.holdRecordArr copy]];
}

-(void)callbackModule{
    __weak typeof(self) weakSelf = self;
    
    [self.topView.gradeView setTapActionWithBlock:^{
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
            weakSelf.topView.gradeLb.text = province;
            if (weakSelf.gradeArr.count > provinceNum) {
                BasicModel *model = weakSelf.gradeArr[provinceNum];
                weakSelf.askModel.gradeId = model.gradeId;
            }
        };
        
    }];
        
        [self.topView.subjectsView setTapActionWithBlock:^{
            [weakSelf.view endEditing:YES];
            
            CountryPickerView *myCountryPickerView = [[CountryPickerView alloc]initWithFrame:weakSelf.view.bounds];
            myCountryPickerView.titleLabel.text = @"选择科目";
            
            NSMutableArray *mutArr = [NSMutableArray new];
            for (NSInteger i = 0; i<weakSelf.subjectArr.count; i++) {
                BasicModel *model = weakSelf.subjectArr[i];
                [mutArr addObject:model.subjectName];
            }
            myCountryPickerView.adressDataArr = mutArr;
            [myCountryPickerView showAddressPickView];
            
            myCountryPickerView.block = ^(NSString *province, NSInteger provinceNum) {
                weakSelf.topView.subjectLb.text = province;
                if (weakSelf.subjectArr.count > provinceNum) {
                    BasicModel *model = weakSelf.subjectArr[provinceNum];
                    weakSelf.askModel.subjectId = model.subjectId;
                }
            };
            
        }];
    
    [self.topView.uploadPicView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        [weakSelf.recordTool stopPlaying];

        [[CHImagePicker shareInstance] showWithController:nil pushController:self finish:^(UIImage *image) {
            
            //            NSLog(@"image=%@",image);
            
            //压缩图片
            //            image = [image imageByResizeToSize:CGSizeMake(104, 104)];
            
            if (weakSelf.imgMutArr.count >= 10) {
                [JRToast showWithText:@"已达到最大值10张图片" bottomOffset:100];
                return ;
            }
            
            [weakSelf.imgMutArr addObject:image];
            [weakSelf.tableView reloadData];
            
        } cancel:^(UIImage *image) {
        } animated:YES];
        
        }];
        

    [self.sumbitView setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
        [weakSelf.recordTool stopPlaying];
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        weakSelf.sumbitView.userInteractionEnabled = NO;
        if (weakSelf.imgMutArr.count > 0 || weakSelf.recordMutArr.count > 0) {
            [weakSelf uploadImgFiles];
        }else{
            [weakSelf uploadTextData];
        }
        
//        [CXAudioPlayer sharedInstance].playUrlStr = @"https://heavenn.oss-cn-shenzhen.aliyuncs.com/erqiimg/20201218185411100037.mp3";
//        [[CXAudioPlayer sharedInstance] play];
        
        
        //https://heavenn.oss-cn-shenzhen.aliyuncs.com/erqiimg/20201218142717100036.mp3
//        weakSelf.player = nil;
//        weakSelf.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:@"https://heavenn.oss-cn-shenzhen.aliyuncs.com/erqiimg/20201218185411100037.mp3"]];
//        [weakSelf.player play];
//        https://blog.csdn.net/lwwwwg/article/details/60142220?utm_medium=distribute.pc_relevant_download.none-task-blog-baidujs-2.nonecase&depth_1-utm_source=distribute.pc_relevant_download.none-task-blog-baidujs-2.nonecase
        
    }];
}

//-(void)toDoRecord{
//    __weak typeof(self) weak_self = self;
//    //手指按下
//    self.topView.recordButton.recordTouchDownAction = ^(ZZJRecordButton *sender){
//
//        //如果用户没有开启麦克风权限,不能让其录音
//        if (![self canRecord]) return ;
//
//        NSLog(@"开始录音");
////        if (sender.highlighted) {
////            sender.highlighted = YES;
////            [sender setButtonStateWithRecording];
////        }
//        [weak_self.recordTool startRecording];
//
//        [weak_self removeView];
//        [weak_self voiceStateWithImage:@"shuohua" labelText:@"按住说话 录音中" isAnimation:YES];
//    };
//
//    //手指抬起
//    self.topView.recordButton.recordTouchUpInsideAction = ^(ZZJRecordButton *sender){
//        NSLog(@"完成录音");
////        [sender setButtonStateWithNormal];
////        weak_self.currentRecordTime = weak_self.recordTool.recorder.currentTime;
////        [self setupPlayButton];
//
//        [weak_self.recordTool stopRecording];
//        [weak_self removeView];
//
//    };
//}

#pragma mark -- Event
// 按下
- (void)recordBtnDidTouchDown:(ZZJRecordButton *)sender {
    
    [self.view endEditing:YES];
    
    //如果用户没有开启麦克风权限,不能让其录音
    if (![self canRecord]) return ;
    
    if (self.recordMutArr.count >= 10) {
        [JRToast showWithText:@"已达到最大值10条语音" bottomOffset:100];
    }else{
        
    NSLog(@"开始录音");
//    if (sender.highlighted) {
//        sender.highlighted = YES;
//        [sender setButtonStateWithRecording];
//    }
    [self.recordTool startRecording];
    
    [self removeView];
    [self voiceStateWithImage:@"shuohua" labelText:@"按住说话 录音中" isAnimation:YES];
    }
}

// 点击（抬起）
- (void)recordBtnDidTouchUpInside:(ZZJRecordButton *)sender {
    
    double currentTime = self.recordTool.recorder.currentTime;
    NSLog(@"%lf", currentTime);
    if (currentTime < 1) {

        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        [self removeView];
        [JRToast showWithText:@"说话时间太短，请按住重录" bottomOffset:100];
    }else{
    
    NSLog(@"点击（抬起）完成录音");
//    [sender setButtonStateWithNormal];
    //        weak_self.currentRecordTime = weak_self.recordTool.recorder.currentTime;
    //        [self setupPlayButton];
    
        [self.recordTool stopRecording];
        [self removeView];
        
        NSString *currentRecordTime = [NSString stringWithFormat:@"%.1lf",currentTime];
        OtherModel *model = [OtherModel new];
        model.recordTimeStr = currentRecordTime;
        model.recordLocalURL = self.recordTool.recordFileUrl;
        model.recordLocalStr = self.recordTool.recordFileStr;
        [self.recordMutArr addObject:model];
        [self.tableView reloadData];
    }
    
}

// 手指从按钮上移除
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
    
    double currentTime = self.recordTool.recorder.currentTime;
    NSLog(@"%lf", currentTime);
    if (currentTime < 1) {
        
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        [self removeView];
        [JRToast showWithText:@"说话时间太短，请按住重录" bottomOffset:100];
    }else{
    
    NSLog(@"手指从按钮上移除完成录音");
    [self.recordTool stopRecording];
    [self removeView];
        
        NSString *currentRecordTime = [NSString stringWithFormat:@"%.1lf",currentTime];
        OtherModel *model = [OtherModel new];
        model.recordTimeStr = currentRecordTime;
        model.recordLocalURL = self.recordTool.recordFileUrl;
        model.recordLocalStr = self.recordTool.recordFileStr;
        [self.recordMutArr addObject:model];
        [self.tableView reloadData];
    }
}

#pragma  tableView -- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.imgMutArr.count%2 == 0) {
            return self.imgMutArr.count/2;
        }else{
            return self.imgMutArr.count/2 + 1;
        }
    }else{
        return self.recordMutArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AskPicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AskPicTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        cell.secondPic.hidden = NO;
        cell.secondDeleteBtn.hidden= NO;
        cell.secondDeleteBtn.enabled = YES;
        cell.firstPic.image = self.imgMutArr[indexPath.row*2];
        if (self.imgMutArr.count > indexPath.row*2 + 1) {
            cell.secondPic.image = self.imgMutArr[indexPath.row*2 + 1];
        }        
        __weak typeof(self) weakSelf = self;
        [cell.firstDeleteBtn setTapActionWithBlock:^{
            [weakSelf.imgMutArr removeObjectAtIndex:indexPath.row*2];
            [weakSelf.tableView reloadData];
        }];
        [cell.secondDeleteBtn setTapActionWithBlock:^{
            [weakSelf.imgMutArr removeObjectAtIndex:indexPath.row*2+1];
            [weakSelf.tableView reloadData];
        }];
        
        if (self.imgMutArr.count%2 == 0) {
            
        }else{
            if (indexPath.row == self.imgMutArr.count/2) {
                cell.secondPic.hidden = YES;
                cell.secondDeleteBtn.hidden= YES;
                cell.secondDeleteBtn.enabled = NO;
            }
        }
        
        return cell;
    }else{
        
        AskVoiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AskVoiceTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = MainBackgroundColor;
        cell.deleteBtn.enabled = YES;
        cell.deleteBtn.hidden = NO;
        cell.vocieLb.text = [NSString stringWithFormat:@"%@''",[self.recordMutArr[indexPath.row] recordTimeStr]];
        __weak typeof(self) weakSelf = self;
        [cell.vocieView setTapActionWithBlock:^{
            weakSelf.recordTool.recordFileUrl = [weakSelf.recordMutArr[indexPath.row] recordLocalURL];
            [weakSelf.recordTool playRecordingFile];
        }];
        [cell.deleteBtn setTapActionWithBlock:^{
            [weakSelf.recordMutArr removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
        }];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 175;
    }else{
        return 47;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


#pragma mark ---- 发布语音的状态来创建提示视图
-(void)voiceStateWithImage:(NSString *)imageName labelText:(NSString *)text isAnimation:(BOOL)Animation
{
    UIImageView * bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_bg"]];
    bgView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    
    UIImageView * stateImageView;
    if (!Animation) {
        stateImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    }else{
        stateImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        stateImageView.animationImages = @[[UIImage imageNamed:imageName],
                                           [UIImage imageNamed:@"donghua_one"],
                                           [UIImage imageNamed:@"donghua_two"],
                                           ];
        stateImageView.animationDuration = 0.6;
        [stateImageView startAnimating];
    }
    stateImageView.y = 50;
    stateImageView.x = 80;
    stateImageView.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:stateImageView];
    self.stateImageView = stateImageView;
    
    
    UILabel * textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = text;
    textLabel.y = CGRectGetMaxY(self.stateImageView.frame) + 25;
    textLabel.x = 0;
    textLabel.width = self.bgView.width;
    textLabel.height = 20;
    [self.bgView addSubview:textLabel];
    self.textLabel = textLabel;
}

#pragma mark ---- 销毁录音提示的视图
-(void)removeView
{
    [self.bgView removeFromSuperview];
    [self.stateImageView removeFromSuperview];
    [self.textLabel removeFromSuperview];
}

#pragma mark -- Other

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:nil
                                                message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                               delegate:nil
                                      cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil] show];
                });
            }
        }];
    }
    return bCanRecord;
}


//#pragma mark -- LVRecordToolDelegate
//-(void)getBackFinishFileURL:(NSURL *)fileUrl AndRecordTimeStr:(NSString *)timeStr{
////    OtherModel *model = [OtherModel new];
////    model.recordTimeStr = timeStr;
////    model.recordLocalURL = fileUrl;
////    [self.recordMutArr addObject:model];
////    [self.tableView reloadData];
//}

#pragma mark - TextfieldViewChange

-(void)changeFootViewColor{
    
    if (self.topView.titleTextfield.text.length > 0 && self.topView.describeTextView.text.length > 0  ) {
        
        self.sumbitView.backgroundColor = KNavColor;
        self.sumbitView.userInteractionEnabled = YES;
        
    }else{
        self.sumbitView.userInteractionEnabled = NO;
        self.sumbitView.backgroundColor = KNavColorHalf;
    }
}

-(void)titleTextChange:(UITextField *)sender{
    [self changeFootViewColor];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.topView.holdLb.hidden = textView.text.length > 0 ? YES : NO;
    [self changeFootViewColor];
    
    float MAXSTRINGLENGTH = 200;//限定输入长度 不减1有bug 实际成了101了
    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *range = [textView markedTextRange];
        UITextPosition *start = range.start;
        UITextPosition*end = range.end;
        NSInteger selectLength = [textView offsetFromPosition:start toPosition:end];
        NSInteger contentLength = textView.text.length - selectLength;
        
        if (contentLength > MAXSTRINGLENGTH) {
            textView.text = [textView.text substringToIndex:MAXSTRINGLENGTH];
            contentLength = MAXSTRINGLENGTH;
        }
        
//        self.numLb.text = [NSString stringWithFormat:@"%lu/100",contentLength];
    }else{
        if (textView.text.length > MAXSTRINGLENGTH){
            textView.text = [textView.text substringToIndex:MAXSTRINGLENGTH];
        }
        
//        self.numLb.text = [NSString stringWithFormat:@"%lu/100",textView.text.length];
    }
    
}


#pragma mark ===== 转换成MP3文件=====
- (NSURL *)audio_PCMtoMP3WithSourceUrl:(NSURL *)sourceUrl
{
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    //NSString *mp3FileName = [strUrl lastPathComponent];
    //mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [strUrl stringByAppendingPathComponent:@"lll.mp3"];
    
    NSString *urlPlay = [sourceUrl absoluteString];

    @try {
        int read, write;

        FILE *pcm = fopen([urlPlay cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);

            fwrite(mp3_buffer, write, 1, mp3);

        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        strUrl = mp3FilePath;
//        _saveModel.speakUrl=[NSURL URLWithString:strUrl];
        NSLog(@"MP3生成成功: %@",strUrl);
        return [NSURL URLWithString:strUrl];
    }

}

@end
