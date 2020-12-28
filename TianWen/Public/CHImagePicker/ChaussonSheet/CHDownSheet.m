//
//  CHDownSheet.m
//
//
//  Created by Chausson on 14-7-19.
//  Copyright (c) 2014年 Chausson. All rights reserved.
//
#define KNavitionBarHeight 64
#import "CHDownSheet.h"
@interface CHDownSheet()
@property (assign ,nonatomic) BOOL isTranslucent;
@end
@implementation CHDownSheet{
     NSArray *listData;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithlist:(NSArray *)list height:(CGFloat)height{
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, IScreenWidth, IScreenHeight);
        self.backgroundColor = RGBACOLOR(0, 0, 0,.7);
        _view = [[UITableView alloc]initWithFrame:CGRectMake(0, IScreenHeight, IScreenWidth,49*[list count]+7 + SafeAreaBottomHeight) style:UITableViewStylePlain];
        _view.dataSource = self;
        _view.delegate = self;
        _view.separatorStyle = NO;
        _view.scrollEnabled = NO;
        listData = list;
        [self addSubview:_view];

    }
    return self;
}
- (void)showInView:(UIViewController *)Sview
{
    
    if(Sview==nil){
        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }else{
        //[view addSubview:self];
        self.isTranslucent =  !Sview.navigationController.navigationBar.isTranslucent && Sview.navigationController.navigationBar;
    
        [Sview.view addSubview:self];
        
    }
    [self animeData];
}

//从隐藏navigation的viewcontroller过来 手动上移位置
- (void)showInView:(UIViewController *)Sview andViewIsHidedNavigationBar:(id)HidTag
{

    if(Sview==nil){
        //        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }else{
        //[view addSubview:self];
        self.isTranslucent =  !Sview.navigationController.navigationBar.isTranslucent && Sview.navigationController.navigationBar;

        self.isTranslucent = YES;
        [Sview.view addSubview:self];
    }
    [self animeData];
}

-(void)animeData{
    //self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel2)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    CGFloat orginY = IScreenHeight - _view.frame.size.height ;
    if (self.isTranslucent) {
        orginY-=KNavitionBarHeight;
    }
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = RGBACOLOR(0, 0, 0,.7);
        [UIView animateWithDuration:.25 animations:^{
            [_view setFrame:CGRectMake(_view.frame.origin.x, orginY, _view.frame.size.width, _view.frame.size.height)];
        }];
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

-(void)tappedCancel{
    [UIView animateWithDuration:.25 animations:^{
        [_view setFrame:CGRectMake(0, IScreenHeight,IScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)tappedCancel2
{
    if (_isFeedAndNoCaiJianFlage) {
        if(_delegate !=nil && [_delegate respondsToSelector:@selector(didSelectIndex:)]){
            [_delegate didSelectIndex:3];
            return;
        }
    }
    [self tappedCancel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listData count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == listData.count-1){
       
      UITableViewCell*  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gap"];
//        cell.contentView.backgroundColor = RGBCOLOR(214, 214, 221);
        cell.contentView.backgroundColor = RGBCOLOR(250, 250, 250);;
        
        return cell;
    }else {
        CHDownSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:[CHDownSheetCell identifier]];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if(cell ==nil ){
            
           cell = [[CHDownSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CHDownSheetCell identifier]];
        }
        if (indexPath.row == listData.count) {
            [cell setData:[listData objectAtIndex:listData.count-1]];
            cell.line.hidden = YES;
        }else {
            cell.line.hidden = NO;
            [cell setData:[listData objectAtIndex:indexPath.row]];
        }
        
         return cell;
    }
    
    
    
    
    
    // Configure the cell...
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tappedCancel];
    if(_delegate !=nil && [_delegate respondsToSelector:@selector(didSelectIndex:)]){
        [_delegate didSelectIndex:indexPath.row];
        return;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == listData.count-1){
        return 7;
    }else{
        return 49;
    }
}
- (void)dealloc{
    
}


@end


