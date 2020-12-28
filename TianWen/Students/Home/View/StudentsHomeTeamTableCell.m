//
//  StudentsHomeTeamTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/11/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "StudentsHomeTeamTableCell.h"
#import "HomeTeamCollectionCell.h"
#import "TeacherDetailViewController.h"
#import "TeacherTeamModel.h"

@interface StudentsHomeTeamTableCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation StudentsHomeTeamTableCell

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向滑动
    flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 10.f);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(130,186);
    
    [self.collectView setCollectionViewLayout:flowLayout];
    
    self.collectView.backgroundColor = [UIColor whiteColor];
    self.collectView.showsVerticalScrollIndicator = NO;
    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.bounces = NO;
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    [self.collectView registerNib:[UINib nibWithNibName:@"HomeTeamCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HomeTeamCollectionCell"];
}

-(void)refreshUI:(NSArray *)arr{
    
    self.dataArr = [arr copy];
    [self.collectView reloadData];

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
    
    HomeTeamCollectionCell *hotCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTeamCollectionCell" forIndexPath:indexPath];
    hotCell.contentView.backgroundColor = [UIColor whiteColor];
    [hotCell refreshUI:self.dataArr[indexPath.row]];
    
    return hotCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count <= 0) {
        return;
    }
    TeacherDetailViewController *teacherVC = [TeacherDetailViewController new];
    teacherVC.titleStr = [self.dataArr[indexPath.row] realName];
    teacherVC.userId = [self.dataArr[indexPath.row] userId];
    [self.nav pushViewController:teacherVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
