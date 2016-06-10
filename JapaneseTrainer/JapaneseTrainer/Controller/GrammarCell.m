//
//  GrammarCell.m
//  JLPTTrainer
//
//  Created by Bao (Brian) L. LE on 6/6/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "GrammarCell.h"

@implementation GrammarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = k11132201Color.CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
