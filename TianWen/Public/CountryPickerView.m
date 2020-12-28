//
//  CountryPickerView.m
//  LPYProjrect
//
//  Created by 伟 on 17/9/27.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "CountryPickerView.h"
//#import "AdreessModel.h"

#define kAddressPickerScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kAddressPickerScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAddressPickerwindowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define kAddressPickerTopViewColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]

@interface CountryPickerView()
@property (nonatomic) UIWindow *rootWindow;


//选中的当前行
@property (nonatomic,assign) NSInteger selectedRowProvince;

@property (nonatomic,assign) NSInteger selectedRowCity;

@property (nonatomic,assign) NSInteger selectedRowDistrict;
@end

//定义弹出高度
static const CGFloat kPickerViewHeight=200;
static const CGFloat kTopViewHeight=45;

@implementation CountryPickerView

{
    NSArray   *_provinces;
    NSArray   *_citys;
    NSArray   *_areas;

    NSString  *_currentProvince;
    NSString  *_currentCity;
    NSString  *_currentDistrict;

    UIView        *_wholeView;
    UIView        *_topView;
    UIPickerView  *_pickerView;

    //自定义
    NSString  *_currentProvinceId;
    NSString  *_currentCityId;
    NSString  *_currentDistrictId;

    NSInteger  currentProvinceNum;

}

+ (id)shareInstance
{
    static CountryPickerView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[CountryPickerView alloc] init];
    });

    return shareInstance;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.currentPickState=NO;

        self.frame = CGRectMake(0, 0, kAddressPickerScreenWidth, kAddressPickerScreenHeight);
        self.backgroundColor=kAddressPickerwindowColor;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAddressPickView)];
        [self addGestureRecognizer:tap];

        [self createData];
        [self createView];
    }
    return self;
}


- (void)createData
{

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"country.json" ofType:nil];

//    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];

//    NSArray *adressArr = [AdreessModel mj_objectArrayWithKeyValuesArray:array];

//    NSMutableArray *proArr = [NSMutableArray arrayWithObject:@"中国"];
//
//    for (NSInteger i = 0; i<adressArr.count; i++) {
//        AdreessModel *model = adressArr[i];
//
//        [proArr addObject:model.name];
//    }

    NSMutableArray *proArr = [NSMutableArray array];

//    for (NSInteger i = 90; i<280; i++) {
//        NSString *str = [NSString stringWithFormat:@"%ld",i];
//
//        [proArr addObject:str];
//    }

    proArr = [@[@"质量问题",@"配件问题",@"少件/漏发",@"与商品描述不符",@"包装/商品残破",@"发票问题",@"其他"] mutableCopy];


//    _provinces = @[@"中国",@"日本",@"韩国",@"台湾",@"菲律宾",@"越南",@"马来西亚",@"新加坡",@"印度尼西亚",@"澳大利亚",@"欧洲  (全欧洲所有国家)",@"马尔代夫",@"斐济",@"帕劳",@"赛班",@"加拿大",@"美国",@"新西兰",@"毛里求斯",@"迪拜"];

    _provinces = [proArr copy];

    _currentProvince = [_provinces objectAtIndex:0];

    currentProvinceNum = 0;

//    //    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addressData" ofType:@"plist"];
//
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
//
//    NSArray *data = [[NSArray alloc]initWithContentsOfFile:plistPath];
//
//    _provinces = data;
//
//    // 第一个省分对应的全部市
//    _citys = [[_provinces objectAtIndex:0] objectForKey:@"city"];
//    // 第一个省份
//    _currentProvince = [[_provinces objectAtIndex:0] objectForKey:@"state"];
//    _currentProvinceId = [[_provinces objectAtIndex:0] objectForKey:@"id"];
//
//
//    // 第一个省份对应的第一个市
//    _currentCity = [[_citys objectAtIndex:0] objectForKey:@"city"];
//    _currentCityId = [[_citys objectAtIndex:0] objectForKey:@"id"];
//
//    // 第一个省份对应的第一个市对应的第一个区
//    _areas = [[_citys objectAtIndex:0] objectForKey:@"areas"];
//    if (_areas.count > 0) {
//        _currentDistrict = [[_areas objectAtIndex:0] objectForKey:@"city"];
//        _currentDistrictId = [[_areas objectAtIndex:0] objectForKey:@"id"];
//    } else {
//        _currentDistrict = @"";
//    }
//
//    //
//    //    self.selectedRowProvince = 0;
//    //
//    //    self.selectedRowCity = 0;
//    //
//    //    self.selectedRowDistrict = 0;

}

-(void)setAdressDataArr:(NSArray *)adressDataArr{
    _adressDataArr = adressDataArr;

    _provinces = [adressDataArr copy];

    _currentProvince = [_provinces objectAtIndex:0];

    currentProvinceNum = 0;

    [_pickerView reloadAllComponents];
}

- (void)createView
{

    // 弹出的整个视图
    _wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, kAddressPickerScreenHeight, kAddressPickerScreenWidth, kPickerViewHeight)];
//    _wholeView.backgroundColor=[UIColor hexStringToColor:@"#f5f4f9"];
    _wholeView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self addSubview:_wholeView];

    // 头部按钮视图
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAddressPickerScreenWidth, kTopViewHeight)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_wholeView addSubview:_topView];

    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor hexStringToColor:@"0C0C0C"];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.text = @"选择";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.offset(0);
        make.top.offset(0);
        make.height.offset(45);
        make.width.offset(200);
    }];

    // 防止点击事件触发
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [_topView addGestureRecognizer:topTap];

    NSArray *buttonimgArray = @[@"Info_cancel",@"Info_sure"];
    NSArray *nameArr = @[@"取消",@"确定"];

    for (int i = 0; i <nameArr.count ; i++)
    {
        //        CGSize size = LabelSizeWithStr(buttonTitleArray[i], CGSizeMake(80, 20), Attributes(15));
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0) {

            button.frame = CGRectMake(15, 12.5, 35, kTopViewHeight - 25);
            [button setTitleColor:JColorFromRGB(0x9C9C9C) forState:UIControlStateNormal];
        }else {

            button.frame = CGRectMake((kAddressPickerScreenWidth-15 - 35), 12.5, 35, kTopViewHeight - 25);
            [button setTitleColor:JColorFromRGB(0x49CA6D) forState:UIControlStateNormal];
        }
        //        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        //        [button setImage:[UIImage imageNamed:buttonimgArray[i]] forState:UIControlStateNormal];
        [button setFont:[UIFont systemFontOfSize:16]];
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        //        button.layer.masksToBounds = YES;
        //        button.layer.cornerRadius = 5.0;
        button.backgroundColor = [UIColor clearColor];
        [_topView addSubview:button];

        button.tag = i;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight-1, KMainScreenWidth, 1)];
        lineView.backgroundColor = [UIColor hexStringToColor:@"#e2e2e2"];
        [_topView addSubview:lineView];

    // 初始化pickerView
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight, kAddressPickerScreenWidth, kPickerViewHeight-kTopViewHeight)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
//    _pickerView.backgroundColor = [UIColor hexStringToColor:@"#f6f8f9"];
    _pickerView.backgroundColor = [UIColor hexStringToColor:@"#ffffff"];
    [_wholeView addSubview:_pickerView];

    CGFloat labWidth = (KMainScreenWidth)/3;

//    UILabel *unitHoldLb = [[UILabel alloc]init];
//    if (KMainScreenWidth <= 320) {
//        [unitHoldLb setFrame:CGRectMake(KMainScreenWidth/2.0f + 20, kTopViewHeight + (kPickerViewHeight-kTopViewHeight)/2.0f - 41/2.0f, 42, 41)];
//    }else{
//    [unitHoldLb setFrame:CGRectMake(KMainScreenWidth/2.0f + 45, kTopViewHeight + (kPickerViewHeight-kTopViewHeight)/2.0f - 41/2.0f, 42, 41)];
//    }
//    unitHoldLb.text = @"次/分";
//    unitHoldLb.textColor = JColorFromRGB(0x8b8a8f);
//    unitHoldLb.font = [UIFont systemFontOfSize:15];
//    [_wholeView addSubview:unitHoldLb];
//    [_wholeView bringSubviewToFront:unitHoldLb];
//
//    self.markLabel = [[UILabel alloc]init];
//    self.markLabel.text = @"较大强度";
//    self.markLabel.textColor = JColorFromRGB(0xf5a623);
//    self.markLabel.font = [UIFont systemFontOfSize:13];
//    self.markLabel.textAlignment = NSTextAlignmentCenter;
//    self.markLabel.backgroundColor = [JColorFromRGB(0xf5a623) colorWithAlphaComponent:0.3f];
//    [_wholeView addSubview:self.markLabel];
//    [_wholeView bringSubviewToFront:self.markLabel];

//    if (KMainScreenWidth <= 320) {
//        [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(unitHoldLb.mas_right).offset(5);
//            make.centerY.equalTo(unitHoldLb.mas_centerY).offset(0);
//            make.width.offset(55);
//            make.height.offset(18);
//        }];
//    }else{
//
//    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(unitHoldLb.mas_right).offset(20);
//        make.centerY.equalTo(unitHoldLb.mas_centerY).offset(0);
//        make.width.offset(58);
//        make.height.offset(18);
//    }];
//    }

    /************************线*************************/

    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _pickerView.frame.size.height / 2.0 -21, KMainScreenWidth, 0.5)];
    line.backgroundColor = JColorFromRGB(0xe2e2e2);
    [_pickerView addSubview:line];

    UILabel *line11 = [[UILabel alloc]initWithFrame:CGRectMake(0,_pickerView.frame.size.height / 2.0 +20, KMainScreenWidth, 0.5)];
    line11.backgroundColor = JColorFromRGB(0xe2e2e2);
    [_pickerView addSubview:line11];

    /*
     UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((labWidth-55)/2, _pickerView.frame.size.height / 2.0 -21, 55, 0.5)];
     line.backgroundColor = JColorFromRGB(0xe2e2e2);
     [_pickerView addSubview:line];

     UILabel *line11 = [[UILabel alloc]initWithFrame:CGRectMake((labWidth-55)/2,_pickerView.frame.size.height / 2.0 +20, 55, 0.5)];
     line11.backgroundColor = JColorFromRGB(0xe2e2e2);
     [_pickerView addSubview:line11];
     //
     UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(labWidth+(labWidth-55)/2, _pickerView.frame.size.height / 2.0 -21, 55, 0.5)];
     line2.backgroundColor = JColorFromRGB(0xe2e2e2);
     [_pickerView addSubview:line2];

     UILabel *line22 = [[UILabel alloc]initWithFrame:CGRectMake(labWidth+(labWidth-55)/2, _pickerView.frame.size.height / 2.0 +20, 55, 0.5)];
     line22.backgroundColor = JColorFromRGB(0xe2e2e2);
     [_pickerView addSubview:line22];

     UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(labWidth*2+(labWidth-55)/2, _pickerView.frame.size.height / 2.0 -21, 55, 0.5)];
     line3.backgroundColor = JColorFromRGB(0xe2e2e2);
     [_pickerView addSubview:line3];

     UILabel *line33 = [[UILabel alloc]initWithFrame:CGRectMake(labWidth*2+(labWidth-55)/2, _pickerView.frame.size.height / 2.0 +20, 55, 0.5)];
     line33.backgroundColor = JColorFromRGB(0xe2e2e2);
     [_pickerView addSubview:line33];
     */


    [self clearSeparatorWithView:_pickerView];

}

- (void)buttonEvent:(UIButton *)button
{
    // 点击确定回调block
    if (button.tag == 1)
    {
        if (_block) {
//            _block(_currentProvince, _currentCity, _currentDistrict,_currentProvinceId,_currentCityId,_currentDistrictId);
            _block(_currentProvince,currentProvinceNum);
        }
    }

    [self hiddenAddressPickView];
}


- (void)showAddressPickView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, kAddressPickerScreenHeight-kPickerViewHeight, kAddressPickerScreenWidth, kPickerViewHeight);

     } completion:^(BOOL finished) {
         self.currentPickState=YES;
         self.rootWindow = [UIApplication sharedApplication].keyWindow;
         [self.rootWindow addSubview:self];
     }];
}

- (void)hiddenAddressPickView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _wholeView.frame = CGRectMake(0, kAddressPickerScreenHeight, kAddressPickerScreenWidth, kPickerViewHeight);
     } completion:^(BOOL finished) {
         self.currentPickState=NO;
         [self removeFromSuperview];
     }];
}


#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 1;  // 返回的列数

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    switch (component) {
//        case 0:
//            return [_provinces count];
//            break;
//        case 1:
//            return [_citys count];
//            break;
//        case 2:
//
//            return [_areas count];
//            break;
//
//        default:
//            return 0;
//            break;
//    }
    return [_provinces count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    switch (component)
//    {
//        case 0:
//            return [[_provinces objectAtIndex:row] objectForKey:@"state"];
//            break;
//        case 1:
//            return [[_citys objectAtIndex:row] objectForKey:@"city"];
//            break;
//        case 2:
//            if ([_areas count] > 0) {
//                return [[_areas objectAtIndex:row] objectForKey:@"city"];
//                break;
//            }
//        default:
//            return  @"";
//            break;
//    }
    return [_provinces objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView selectRow:row inComponent:component animated:YES];

    _currentProvince = [_provinces objectAtIndex:row];

    currentProvinceNum = row;

//    switch (component)
//    {
//        case 0:
//
//            [_pickerView reloadComponent:0];
//            self.selectedRowProvince = row;
//            self.selectedRowCity = 0;
//            _citys = [[_provinces objectAtIndex:row] objectForKey:@"city"];
//            [_pickerView selectRow:0 inComponent:1 animated:YES];
//            [_pickerView reloadComponent:1];
//
//            _areas = [[_citys objectAtIndex:0] objectForKey:@"areas"];
//
//
//            [_pickerView selectRow:0 inComponent:2 animated:YES];   //返回2列时注释
//            [_pickerView reloadComponent:2];
//
//            _currentProvince = [[_provinces objectAtIndex:row] objectForKey:@"state"];
//            _currentProvinceId = [[_provinces objectAtIndex:0] objectForKey:@"id"];
//            _currentCity = [[_citys objectAtIndex:0] objectForKey:@"city"];
//            _currentCityId = [[_citys objectAtIndex:0] objectForKey:@"id"];
//            if ([_areas count] > 0) {
//                _currentDistrict = [[_areas objectAtIndex:0] objectForKey:@"city"];
//                _currentDistrictId = [[_areas objectAtIndex:0] objectForKey:@"id"];
//            } else{
//                _currentDistrict = @"";
//            }
//            break;
//
//        case 1:
//            self.selectedRowCity = row;
//            self.selectedRowDistrict = 0;
//            [_pickerView reloadComponent:1];
//            _areas = [[_citys objectAtIndex:row] objectForKey:@"areas"];
//
//            [_pickerView selectRow:0 inComponent:2 animated:YES];  //返回2列时注释
//            [_pickerView reloadComponent:2];
//
//            _currentCity = [[_citys objectAtIndex:row] objectForKey:@"city"];
//            _currentCityId = [[_citys objectAtIndex:0] objectForKey:@"id"];
//            if ([_areas count] > 0) {
//                _currentDistrict = [[_areas objectAtIndex:0] objectForKey:@"city"];
//                _currentDistrictId = [[_areas objectAtIndex:0] objectForKey:@"id"];
//            } else {
//                _currentDistrict = @"";
//            }
//            break;
//
//        case 2:
//
//            self.selectedRowDistrict = row;
//            [_pickerView reloadComponent:2];
//            if ([_areas count] > 0) {
//                _currentDistrict = [[_areas objectAtIndex:row] objectForKey:@"city"];
//                _currentDistrictId = [[_areas objectAtIndex:0] objectForKey:@"id"];
//            } else{
//                _currentDistrict = @"";
//            }
//            break;
//
//        default:
//            break;
//    }
}

- (void)clearSeparatorWithView:(UIView * )view
{
    //    if(view.subviews != 0  )
    //    {
    //        if(view.bounds.size.height < 1  && view.bounds.size.width != 55)
    //        {
    //            view.backgroundColor = [UIColor clearColor];
    //        }
    //
    //        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
    //            [self clearSeparatorWithView:obj];
    //        }];
    //    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

    for(UIView *speartorView in _pickerView.subviews)
    {

        if (speartorView.frame.size.height < 1 &&speartorView.frame.size.width != 55 &&speartorView.frame.size.width != KMainScreenWidth)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor clearColor];//隐藏分割线
        }
    }



    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
//        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth/3+1, 40+1)];
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth+1, 40+1)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.textColor = [UIColor hexStringToColor:@"a1a5af"];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }

    pickerLabel.backgroundColor = [UIColor whiteColor];
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];


//    if (component ==  0) {
//        if (row == self.selectedRowProvince) {
            pickerLabel.textColor = [UIColor hexStringToColor:@"#424e64"];
    [pickerLabel setFont:[UIFont systemFontOfSize:20]];
//        }
//    }
//    else if (component == 1)
//    {
//        if (row == self.selectedRowCity) {
//            pickerLabel.textColor = [UIColor hexStringToColor:@"#222222"];
//        }
//    }
//    else
//    {
//        if (row == self.selectedRowDistrict) {
//            pickerLabel.textColor = [UIColor hexStringToColor:@"#222222"];
//        }
//    }


//    UIView *pickView = (UIView *)view;
//
//    if (!pickView) {
//        pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth+1, 40+1)];
//        pickView.backgroundColor = [UIColor whiteColor];
//
//        UILabel *pickLb = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth/2.0f - 60/2.0f, 0, 60, 40)];
//        pickLb.backgroundColor = [UIColor clearColor];
//        pickLb.textColor = JColorFromRGB(0x8b8a8f);
//        pickLb.font = [UIFont systemFontOfSize:13];
//        pickLb.tag = 500;
//        [pickView addSubview:pickLb];
//    }
//
//    UILabel *picklb = (UILabel *)[self viewWithTag:500];
//    picklb.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//    picklb.textColor = JColorFromRGB(0x0f0f0f);
//    picklb.font = [UIFont systemFontOfSize:16];

    return pickerLabel;

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;

}

#pragma mark 默认绑定设置

-(void)configDataProvince:(NSString *)provinceName City:(NSString *)cityName Town:(NSString *)townName
{
    NSString *provinceStr = provinceName;
    NSString *cityStr = cityName;
    NSString *districtStr = townName;

    int oneColumn=0, twoColumn=0, threeColum=0;

    // 省份
    for (int i=0; i<_provinces.count; i++)
    {
        if ([provinceStr isEqualToString:[_provinces[i] objectForKey:@"state"]]) {
            oneColumn = i;
        }
    }

    // 用来记录是某个省下的所有市
    NSArray *tempArray = [_provinces[oneColumn] objectForKey:@"city"];
    // 市
    for  (int j=0; j<[tempArray count]; j++)
    {
        if ([cityStr isEqualToString:[tempArray[j] objectForKey:@"city"]])
        {
            twoColumn = j;
            break;
        }
    }

    // 区
    for (int k=0; k<[[tempArray[twoColumn] objectForKey:@"areas"] count]; k++)
    {
        if ([districtStr isEqualToString:[tempArray[twoColumn] objectForKey:@"areas"][k]])
        {
            threeColum = k;
            break;
        }
    }

    [self pickerView:_pickerView didSelectRow:oneColumn inComponent:0];
    [self pickerView:_pickerView didSelectRow:twoColumn inComponent:1];
    [self pickerView:_pickerView didSelectRow:threeColum inComponent:2];
}

@end
