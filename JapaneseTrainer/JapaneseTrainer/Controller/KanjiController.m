//
//  KanjiController.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/30/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "KanjiController.h"

@interface KanjiController ()<KanjiMeaningDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbKanji;
@property (weak, nonatomic) IBOutlet UILabel *lbReading;
@property (weak, nonatomic) IBOutlet UILabel *lbMeaning;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UITextView *tvExample;

@end

@implementation KanjiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].kanjiMeaningDelegate = self;
    [self requestMeaningKanji];
}

- (void)config {
    self.lbKanji.text = self.word.kanjiWord;
    
    // Border subview layer
    self.subView.layer.cornerRadius = 5.0;
    self.subView.layer.masksToBounds = YES;
}

- (void)requestMeaningKanji {
    ProgressBarShowLoading(kLoading);
    NSString *url = [NSString stringWithFormat:kKanjiTangori,self.word.kanjiWord];
    [[DataManager shared] getKanjiMeaningWithUrl:url];
}
- (IBAction)btnDelete:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Kanji Meaning Delegate

- (void)getKanjiMeaningAPISuccess:(NSData *)response {
    ProgressBarDismissLoading(kEmpty);
    
    // Parse Data from HTML
    TFHpple *kanjiParser = [TFHpple hppleWithHTMLData:response];
    NSArray *kanjiReadingNode = [kanjiParser searchWithXPathQuery:kReadingKanjiTag];
    NSArray *kanjiMeaningNode = [kanjiParser searchWithXPathQuery:kMeaningKanjiTag];
//    NSArray *kanjiDrawNode = [kanjiParser searchWithXPathQuery:kDrawKanjiTag];
    NSArray *kanjiExampleNode = [kanjiParser searchWithXPathQuery:kExampleKanjiTag];
    
    for (TFHppleElement *elementReading in kanjiReadingNode) {
        NSString *kanjiReading = [elementReading content];
        kanjiReading = [kanjiReading stringByAppendingString:kHTMLFontSize15];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[kanjiReading
                                                                                         dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                     documentAttributes:nil error:nil];
        self.lbReading.attributedText = attributedString;
        break;
    }
    for (TFHppleElement *elementMeaning in kanjiMeaningNode) {
        NSString *kanjiMeaning = [elementMeaning content];
        kanjiMeaning = [kanjiMeaning stringByAppendingString:kHTMLFontSize15];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[kanjiMeaning
                                                                                         dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                     documentAttributes:nil error:nil];
        self.lbMeaning.attributedText = attributedString;
        break;
    }
    for (TFHppleElement *elementExample in kanjiExampleNode) {
        NSString *kanjiExample = [elementExample raw];
        kanjiExample = [kanjiExample stringByAppendingString:kHTMLFontSize20];
        NSMutableAttributedString *englishHtml = [[NSMutableAttributedString alloc] initWithData:[kanjiExample dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.tvExample.attributedText = englishHtml;
        break;
    }
}

- (void)getKanjiMeaningAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmpty);
}

@end
