//
//  CHDownSheetCell.m
//
//
//  Created by Chausson on 14-7-19.
//  Copyright (c) 2014年 Chausson. All rights reserved.
//

#import "CHDownSheetCell.h"

@implementation CHDownSheetCell{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        leftView = [[UIImageView alloc]init];
        self.line = [[UIImageView alloc]init];
        InfoLabel = [[UILabel alloc]init];
        InfoLabel.tag = 101;
        InfoLabel.backgroundColor = [UIColor clearColor];
      //  [self.contentView addSubview:leftView];
//        self.contentView.backgroundColor = RGBCOLOR(244, 244, 244);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:InfoLabel];
        [self.contentView addSubview:self.line];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.line.backgroundColor = RGBCOLOR(250,250,250);
    leftView.frame = CGRectMake(20, (self.frame.size.height-20)/2, 20, 20);
    self.line.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    InfoLabel.frame = CGRectMake(self.frame.size.width/2-200/2, (self.frame.size.height-20)/2, 200, 20);
    InfoLabel.textAlignment = 1;
    InfoLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
    if ([cellData.title isEqualToString:@"取消"]) {
//        InfoLabel.textColor = RGBCOLOR(221, 57, 44);
        InfoLabel.textColor = [UIColor hexStringToColor:@"#a2a1a9"];
    }

}

-(void)setData:(CHDownSheetModel *)dicdata{
   
    cellData = dicdata;

  //  leftView.image = [UIImage imageNamed:dicdata.icon];
    InfoLabel.text = dicdata.title;
  
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    if(selected){
//        self.backgroundColor = RGBCOLOR(142 , 142, 142);
//     //   leftView.image = [UIImage imageNamed:cellData.icon_on];
//        InfoLabel.textColor = [UIColor whiteColor];
//    }else{
//        self.backgroundColor = [UIColor whiteColor];
//     //   leftView.image = [UIImage imageNamed:cellData.icon];
//        InfoLabel.textColor = [UIColor blackColor];
//    }
    // Configure the view for the selected state
}
+ (NSString *)identifier{
    return NSStringFromClass(self.class);
}
@end


