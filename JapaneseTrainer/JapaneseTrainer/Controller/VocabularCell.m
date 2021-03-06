//
//  VocabularCell.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/25/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "VocabularCell.h"
#import "NSMutableAttributedString+Color.h"

@implementation VocabularCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Utilities circleButton:self.btnSound];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadInformation:(BOOL)isSearch {
    if (isSearch) {
        self.lbHiragana.text = [NSString stringWithFormat:@"Read: %@", [self.aVocabulary.read lowercaseString]];
        
        // Show kanji string
        NSMutableAttributedString *kanjiString;
        if (self.aVocabulary.nameKanji.length > 0) {
            kanjiString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@【 %@ 】", self.aVocabulary.nameHiragana, self.aVocabulary.nameKanji]];
        } else {
            kanjiString = [[NSMutableAttributedString alloc] initWithString:self.aVocabulary.nameHiragana];
        }
        
        [kanjiString setColorForText:self.aVocabulary.nameKanji withColor:kBrownColor];
        self.lbKanji.attributedText = kanjiString;
        
        // Show meaning html
        NSString *english = [NSString stringWithFormat:@"Meaning: %@", [self.aVocabulary.nameEnglish stringByAppendingString:kHTMLFontSize15]];
        
        NSMutableAttributedString *englishHtml = [[NSMutableAttributedString alloc] initWithData:[english dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [englishHtml addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, englishHtml.length)];
        self.lbEnglish.attributedText = englishHtml;
        
    } else {
        self.lbKanji.text = self.aVocabulary.nameHiragana;
        self.lbEnglish.text = [NSString stringWithFormat:@"Meaning: %@", self.aVocabulary.nameEnglish];
        self.lbHiragana.text = [NSString stringWithFormat:@"Kanji: %@", self.aVocabulary.nameKanji];
    }
    
}
- (IBAction)btnSound:(id)sender {
    [[Sound shared] playSoundWithText:self.aVocabulary.nameHiragana];
}

@end
