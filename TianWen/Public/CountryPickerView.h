//
//  CountryPickerView.h
//  LPYProjrect
//
//  Created by 伟 on 17/9/27.
//  Copyright © 2017年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef  void(^AdressBlock)(NSString *province, NSString *city, NSString *district,NSString *provinceId,NSString *cityId,NSString *districtId);
typedef  void(^CountryBlock)(NSString *province,NSInteger provinceNum);


@interface CountryPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,copy) CountryBlock block;

//当前弹出视图的显示状态(YES 处于弹出状态 NO 隐藏状态)
@property(nonatomic)BOOL currentPickState;

+ (id)shareInstance;

//显示
-(void)showAddressPickView;

//隐藏
-(void)hiddenAddressPickView;

//绑定默认值 省名 市名 区名
-(void)configDataProvince:(NSString *)provinceName City:(NSString *)cityName Town:(NSString *)townName;


@property (nonatomic, strong) NSArray *adressDataArr;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *markLabel;

@end
