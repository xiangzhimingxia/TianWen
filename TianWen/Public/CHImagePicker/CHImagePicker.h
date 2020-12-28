//
//  CHImagePicker.h
//  CHPickImageDemo
//
//  Created by Chausson on 16/3/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickCallback)(UIImage* image);
typedef void (^CancelCallback)(UIImage* image);



@interface CHImagePicker : NSObject

+ (instancetype) new __unavailable;
- (instancetype) init __unavailable;

+ (CHImagePicker *)shareInstance;

+ (CHImagePicker *)shareNoCutInstance;//这个实例化出来的 不裁剪图片 反馈上图用


- (void)showWithController:(UIViewController *)controller
                    finish:(PickCallback)callback
                  animated:(BOOL)animated;


//选择照片 非裁剪
- (void)showWithController:(UIViewController *)controller
                    pushController:(UIViewController *)pushController
                    finish:(PickCallback)callback
                    cancel:(CancelCallback)cancelCallback
                  animated:(BOOL)animated;


@end
