//
//  StudentsHomeActivityTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsHomeActivityTableCell.h"
#import "HomeActivityCollectionCell.h"
#import "ActivityDetailsViewController.h"
#import "ActityModel.h"

@interface StudentsHomeActivityTableCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation StudentsHomeActivityTableCell

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.moreBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:5];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向滑动
    flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 10.f);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(260,135);
    
    [self.collectView setCollectionViewLayout:flowLayout];
    
    self.collectView.backgroundColor = [UIColor whiteColor];
    self.collectView.showsVerticalScrollIndicator = NO;
    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.bounces = NO;
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    [self.collectView registerNib:[UINib nibWithNibName:@"HomeActivityCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HomeActivityCollectionCell"];
}

-(void)refreshUI:(NSArray *)arr{
    
        self.dataArr = [arr copy];
        [self.collectView reloadData];
    //
    //    if (self.dataArr.count == 0) {
    //        self.height = 15.0*2.0 + 18.0;
    //        self.collectView.hidden = YES;
    //    }else{
    //        self.height = 180.0;
    //        self.collectView.hidden = NO;
    //    }
    
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeActivityCollectionCell *hotCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeActivityCollectionCell" forIndexPath:indexPath];
    hotCell.contentView.backgroundColor = [UIColor whiteColor];
    [hotCell refreshUI:self.dataArr[indexPath.row]];
    return hotCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ActivityDetailsViewController *vc = [ActivityDetailsViewController new];
        vc.titleStr = @"画出夏天的颜色";
        vc.isType = 2;
        [self.nav pushViewController:vc animated:YES];
    }else{
        ActivityDetailsViewController *vc = [ActivityDetailsViewController new];
        vc.titleStr = @"画出夏天的颜色";
        vc.isType = 1;
        [self.nav pushViewController:vc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
