//
//  CHImagePicker.m
//  CHPickImageDemo
//
//  Created by Chausson on 16/3/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "CHImagePicker.h"
#import "CHDownSheet.h"

@interface CHImagePicker()<CHDownSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end
@implementation CHImagePicker{
    UIViewController *_screenController;
    NSArray *_pickList;
    PickCallback _callback;
    CancelCallback _cancelCallback;
    BOOL _animated;
    BOOL _isFeedBackNoCaiJianFlage;//来自反馈页面 不裁剪
}
+ (CHImagePicker *)shareInstance{
    static CHImagePicker * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance->_pickList = [instance avaiablePickerSheetModel];
    });
    return instance;
}

+ (CHImagePicker *)shareNoCutInstance//这个实例化出来的 不裁剪图片 反馈上图用
{
    static CHImagePicker * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance->_pickList = [instance avaiablePickerSheetModel];
    });
    return instance;
}

- (void)showWithController:(UIViewController *)controller
                    finish:(PickCallback)callback
                  animated:(BOOL)animated{
    NSAssert(controller, @"Controller can not be nil !");
    _callback = callback;
    _screenController = controller;
    _animated = animated;
    CHDownSheet *sheet = [[CHDownSheet alloc]initWithlist:_pickList height:330];
    sheet.delegate = self;
    [sheet showInView:controller];
}

-(void)showWithController:(UIViewController *)controller pushController:(UIViewController *)pushController finish:(PickCallback)callback cancel:(CancelCallback)cancelCallback animated:(BOOL)animated{
//    NSAssert(controller, @"Controller can not be nil !");
    _callback = callback;
    _cancelCallback = cancelCallback;
    _isFeedBackNoCaiJianFlage = YES;
    _screenController = pushController;
    _animated = animated;
    CHDownSheet *sheet = [[CHDownSheet alloc]initWithlist:_pickList height:330];
    sheet.delegate = self;
    sheet.isFeedAndNoCaiJianFlage = _isFeedBackNoCaiJianFlage;
    [sheet showInView:controller];
}
//- (void)showWithController:(UIViewController *)controller
//                    finish:(PickCallback)callback
//                    cancel:(CancelCallback)cancelCallback
//                  animated:(BOOL)animated{
//    NSAssert(controller, @"Controller can not be nil !");
//    _callback = callback;
//    _cancelCallback = cancelCallback;
//    _isFeedBackNoCaiJianFlage = YES;
//    _screenController = controller;
//    _animated = animated;
//    CHDownSheet *sheet = [[CHDownSheet alloc]initWithlist:_pickList height:330];
//    sheet.delegate = self;
//    sheet.isFeedAndNoCaiJianFlage = _isFeedBackNoCaiJianFlage;
//    [sheet showInView:controller];
//}

-(NSArray *)avaiablePickerSheetModel{
    CHDownSheetModel *Model_1 = [[CHDownSheetModel alloc]init];
    Model_1.title = @"拍照";
    CHDownSheetModel *Model_2 = [[CHDownSheetModel alloc]init];
    Model_2.title = @"从手机相册选择";
    CHDownSheetModel *Model_3 = [[CHDownSheetModel alloc]init];
    Model_3.title = @"取消";

    return   @[Model_1,Model_2,Model_3];
}
-(void)didSelectIndex:(NSInteger)index{
    if (index == 0) {
        //拍照[self openCamera:self];
        [self openCamera];
    }else if (index == 1){
        //相册 [self openPhotoLibrary:self];
        [self openPhotoLibrary];
    }else if (index == 3){
        if (_cancelCallback) {
            _cancelCallback(nil);
        }
    }
}
#pragma mark 打开照相机
- (void)openCamera{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType =  UIImagePickerControllerSourceTypeCamera;
    }
    //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.sourceType = sourceType;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    if (_isFeedBackNoCaiJianFlage) {
        pickerImage.allowsEditing = NO;
    }
    pickerImage.mediaTypes = @[(NSString *)kUTTypeImage];

    
    [_screenController presentViewController:pickerImage animated:_animated completion:^{}];
}

#pragma mark 打开相册
- (void)openPhotoLibrary{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }else{
        
    }
    pickerImage.sourceType = sourceType;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    if (_isFeedBackNoCaiJianFlage) {
        pickerImage.allowsEditing = NO;
    }
    pickerImage.mediaTypes = @[(NSString *)kUTTypeImage];

    [_screenController presentViewController:pickerImage animated:_animated completion:^{}];
}
#pragma mark - Imagepicker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:_animated completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (_isFeedBackNoCaiJianFlage) {
            image =[info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (_callback) {
            _callback(image);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_cancelCallback) {
            _cancelCallback(nil);
        }
    }];

}











@end
