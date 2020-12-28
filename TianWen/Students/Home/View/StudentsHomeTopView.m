//
//  StudentsHomeTopView.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/19.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsHomeTopView.h"

@implementation StudentsHomeTopView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.SearchView.layer.cornerRadius = 20;
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)];
    [self.SearchView addGestureRecognizer:searchTap];
    
}

-(void)searchAction:(UITapGestureRecognizer *)tap{
    if (_homeDelagate && [_homeDelagate respondsToSelector:@selector(clickSearchAction)]) {
        [_homeDelagate clickSearchAction];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
