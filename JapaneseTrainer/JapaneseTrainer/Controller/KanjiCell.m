//
//  KanjiCell.m
//  JLPTTrainer
//
//  Created by Bao (Brian) L. LE on 6/7/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "KanjiCell.h"

@implementation KanjiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadInformation:(Kanji *)kanji {
    self.lbKunyomi.text = kanji.kunyomi;
    self.lbExample.attributedText = [Utilities convertStringToNSAttributeString:[kanji.example stringByAppendingString:kHTMLFontSize15]];
}

@end
