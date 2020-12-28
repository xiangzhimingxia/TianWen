//
//  UIImage+FixOrientation.h
//  BaseProject
//
//  Created by 杨子恒 on 2017/8/11.
//  Copyright © 2017年 JLKF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)

- (UIImage *)fixOrientation;
- (UIImage *)gaussBlurWithLevel:(CGFloat)blurLevel;
@end
