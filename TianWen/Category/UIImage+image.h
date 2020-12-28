//
//  UIImage+image.h
//  中盾app
//
//  Created by Xcode on 16/8/4.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (image)
//设置不要渲染图片
+ (instancetype)imageWithRenderImage: (NSString *)imageName;
+ (UIImage *)imageByColor:(UIColor *)color;
//一个三角形
+ (UIImage *)triangle;

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

- (UIImage *)circleImage;


@end
