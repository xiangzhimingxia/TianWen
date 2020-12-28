//
//  OrderHaveEvaluationTableCell.m
//  TianWen
//
//  Created by 朱伟 on 2020/12/21.
//  Copyright © 2020 ZW. All rights reserved.
//

#import "OrderHaveEvaluationTableCell.h"

@implementation OrderHaveEvaluationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI:(OrderListModel *)model{
    switch ([model.isSatisfied integerValue]) {
        case 0:
            self.pariseLb.text = @"不满意";
            break;
        case 1:
            self.pariseLb.text = @"一般";
            break;
        case 2:
            self.pariseLb.text = @"满意";
            break;
            
        default:
            break;
    }
    
    switch ([model.score integerValue]) {
        case 1:
            {
                self.xin1.hidden = NO;
            }
            break;
        case 2:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
        }
            break;
        case 3:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
        }
            break;
        case 4:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
            self.xin4.hidden = NO;
        }
            break;
        case 5:
        {
            self.xin1.hidden = NO;
            self.xin2.hidden = NO;
            self.xin3.hidden = NO;
            self.xin4.hidden = NO;
            self.xin5.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    self.evalutionLb.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
