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
@property (weak, nonatomic) IBOutlet UIWebView *webviewWritingKanji;
@property (weak, nonatomic) IBOutlet UIView *viewInformation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnSeg;
@property (weak, nonatomic) IBOutlet UIButton *btnSound;
@property (weak, nonatomic) IBOutlet UIImageView *imgWriting;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTopSubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csBottomSubView;
@property (weak, nonatomic) IBOutlet UIView *subViewTop;
@property (weak, nonatomic) IBOutlet UIButton *btnBookmark;

@end

@implementation KanjiController

#pragma mark Life Cycle

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
    [self setInformation];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tvExample scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
}

#pragma mark Helper Method

- (void)config {
    self.lbKanji.text = self.word.kanjiWord;
    
    // Border subview layer
    self.subView.layer.cornerRadius = 5.0;
    self.subView.layer.masksToBounds = YES;
    self.webviewWritingKanji.scrollView.scrollEnabled = NO;
    self.webviewWritingKanji.scrollView.bounces = NO;
    [Utilities circleButton:self.btnSound];
    [Utilities borderView:self.subViewTop];
    [Utilities borderView:self.tvExample];
}

- (void)requestMeaningKanji {
    
    if (self.word.kanjiReading.length > 0) {
        [self loadInformationFromData];
        
    } else {
        ProgressBarShowLoading(kLoading);
        NSString *url = [NSString stringWithFormat:kKanjiTangori,self.word.kanjiWord];
        [[DataManager shared] getKanjiMeaningWithUrl:url];
    }
}

- (void)loadInformationFromData {
    // Reading
    self.lbReading.attributedText = [Utilities convertStringToNSAttributeString:self.word.kanjiReading];
//    self.lbReading.text = [NSString stringWithFormat:@"%@\n%@", self.word.onyomi, self.word.kunyomi];
    // Meaning
//    self.lbMeaning.attributedText = [Utilities convertStringToNSAttributeString:self.word.kanjiMeaning];
    self.lbMeaning.text = self.word.englishMeaning;
    
    // Example
    NSMutableAttributedString *englishHtml = [[NSMutableAttributedString alloc] initWithData:[self.word.kanjiExample dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [englishHtml addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, englishHtml.length)];
    [englishHtml addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, englishHtml.length)];
    
    self.tvExample.attributedText = englishHtml;
    [self.webviewWritingKanji loadHTMLString:self.word.kanjiDrawing baseURL:nil];
}

- (IBAction)btnDelete:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setInformation {
    if (self.word) {
        // Kanji
        self.imgWriting.hidden = YES;
        self.btnSeg.hidden = NO;
        self.viewInformation.hidden = NO;
        self.lbKanji.hidden = NO;
        [self requestMeaningKanji];
        
        self.csTopSubView.constant = kConstantSubViewKanji;
        self.csBottomSubView.constant = kConstantSubViewKanji;
        
    } else {
        // Not kanji
        self.imgWriting.hidden = NO;
        self.btnSeg.hidden = YES;
        self.viewInformation.hidden = YES;
        self.lbKanji.hidden = YES;
        
        NSString *imageText = [self.dictPlist objectForKey:kImageKey];
        if (imageText.length > 0) {
            self.imgWriting.image = [UIImage imageNamed:imageText];
        }
        
        self.csTopSubView.constant = kConstantSubViewHiragana;
        self.csBottomSubView.constant = kConstantSubViewHiragana;
    }
}

- (IBAction)btnSeg:(id)sender {
    
    switch (self.btnSeg.selectedSegmentIndex) {
        case kSegInforKanji: {
            self.webviewWritingKanji.hidden = YES;
            self.viewInformation.hidden = NO;
        }
            break;
            
        default: {
            self.webviewWritingKanji.hidden = NO;
            self.viewInformation.hidden = YES;
        }
            break;
    }
    
}
- (IBAction)btnSound:(id)sender {
     [[Sound shared] playSoundWithText:self.lbKanji.text];
}

#pragma mark Kanji Meaning Delegate

- (void)getKanjiMeaningAPISuccess:(NSData *)response {
    ProgressBarDismissLoading(kEmpty);
    
    // Parse Data from HTML
    TFHpple *kanjiParser = [TFHpple hppleWithHTMLData:response];
    NSArray *kanjiReadingNode = [kanjiParser searchWithXPathQuery:kReadingKanjiTag];
    NSArray *kanjiMeaningNode = [kanjiParser searchWithXPathQuery:kMeaningKanjiTag];
    NSArray *kanjiDrawNode = [kanjiParser searchWithXPathQuery:kDrawKanjiTag];
    NSArray *kanjiExampleNode = [kanjiParser searchWithXPathQuery:kExampleKanjiTag];
    
    for (TFHppleElement *elementReading in kanjiReadingNode) {
        NSString *kanjiReading = [elementReading content];
        kanjiReading = [kanjiReading stringByAppendingString:kHTMLFontSize15];
        kanjiReading = [kanjiReading stringByReplacingOccurrencesOfString:@"/    " withString:@"<br>"];
        self.word.kanjiReading = kanjiReading;
        break;
    }
    for (TFHppleElement *elementMeaning in kanjiMeaningNode) {
        NSString *kanjiMeaning = [elementMeaning content];
        kanjiMeaning = [kanjiMeaning stringByAppendingString:kHTMLFontSize15];
        self.word.kanjiMeaning = kanjiMeaning;
        break;
    }
    for (TFHppleElement *elementExample in kanjiExampleNode) {
        NSString *kanjiExample = [elementExample raw];
        self.word.kanjiExample = kanjiExample;
        break;
    }
    
    for (TFHppleElement *elementKanji in kanjiDrawNode) {
        NSString *kanjiSVG= [elementKanji raw];
        [kanjiSVG stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        [kanjiSVG stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        self.word.kanjiDrawing = kanjiSVG;
        break;
    }
    
    [self.word commit];
    
    [self loadInformationFromData];
}

- (void)getKanjiMeaningAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmpty);
}

@end
