//
//  ArticleDetailViewController.h
//  TianWen
//
//  Created by 朱伟 on 2020/11/22.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "JLKFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshBlock)(void);

@interface ArticleDetailViewController : JLKFBaseViewController

kStr(questionId);

@property (nonatomic, copy) RefreshBlock block;

@end

NS_ASSUME_NONNULL_END
