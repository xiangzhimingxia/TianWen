//
//  TeacherDetailViewController.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "JLKFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshBlock)(void);

@interface TeacherDetailViewController : JLKFBaseViewController

kStr(titleStr);
kStr(userId);

@property (nonatomic, copy) RefreshBlock block;

@end

NS_ASSUME_NONNULL_END
