//
//  DetailGrammarController.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/25/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "DetailGrammarController.h"

@interface DetailGrammarController ()<GetDetailGrammarDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tvDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbWord;
@property (weak, nonatomic) IBOutlet UILabel *lbKanji;
@property (weak, nonatomic) IBOutlet UIButton *btnSound;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeightTopView;
@end

@implementation DetailGrammarController

# pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].getDetailDelegate = self;
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Helper Method

- (void)config {
    // set layer
    [Utilities circleButton:self.btnSound];
    
    // Set text
    if (self.aGrammar) {
        self.lbWord.text = self.aGrammar.name;
        self.csHeightTopView.constant = kHeightConstantGrammar;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.aGrammar.rawExample dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.tvDetail.attributedText = attributedString;
    } else if (self.aVocabulary) {
        self.lbWord.text = self.aVocabulary.nameHiragana;
        self.lbKanji.text = [NSString stringWithFormat:@"Kanji: %@",self.aVocabulary.nameKanji];
        
        // Show meaning html
        if (self.aVocabulary.rawExample.length > 0) {
            self.aVocabulary.rawExample = [self.aVocabulary.rawExample stringByAppendingString:kHTMLFontSize15];
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.aVocabulary.rawExample
                                                                                             dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                    options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                         documentAttributes:nil error:nil];
            self.tvDetail.attributedText = attributedString;

        } else {
            // Show meaning html
            NSString *english = [NSString stringWithFormat:@"Meaning: %@", [self.aVocabulary.nameEnglish stringByAppendingString:kHTMLFontSize15]];
            
            NSMutableAttributedString *englishHtml = [[NSMutableAttributedString alloc] initWithData:[english dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [englishHtml addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, englishHtml.length)];
            self.tvDetail.attributedText = englishHtml;
        }
        
        self.csHeightTopView.constant = kHeightConstantVocabulary;
    }
}

- (IBAction)btnSound:(id)sender {
    if (self.aGrammar) {
        [[Sound shared] playSoundWithText:self.aGrammar.name];
    } else if (self.aVocabulary) {
        [[Sound shared] playSoundWithText:self.aVocabulary.nameHiragana];
    }
    
}

# pragma mark Get Detail Delegate

- (void)getDetailGrammarAPISuccess:(NSData *)response {
    ProgressBarDismissLoading(kEmpty);
    
    // Parse Data from HTML
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:response];
    NSArray *grammarNode = [tutorialsParser searchWithXPathQuery:kQueryDetailGrammar];
    NSString *finalString = kEmpty;
    
    for (int i = 0; i < grammarNode.count; i++) {
        TFHppleElement *element = grammarNode[i];
        
        if ([finalString isEqualToString:kEmpty]) {
            finalString = [NSString stringWithFormat:kRedHTML,i+1, [element raw]];
        } else {
            NSString *raw = [NSString stringWithFormat:kBoldNumberHTML,i+1, [element raw]];
            finalString = [finalString stringByAppendingString:raw];
        }
        finalString = [finalString stringByAppendingString:kHTMLFontSize17];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[finalString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.aGrammar.rawExample = finalString;
        [self.aGrammar commit];
        self.tvDetail.attributedText = attributedString;
    }
}


- (void)getDetailGrammarAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmpty);
}

@end
