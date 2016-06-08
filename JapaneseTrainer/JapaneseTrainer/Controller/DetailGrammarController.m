//
//  DetailGrammarController.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/25/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "DetailGrammarController.h"

@interface DetailGrammarController ()<GetDetailGrammarDelegate, UITableViewDelegate,  UITableViewDataSource, SearchWordDelegate, NoteControllerDelegate, NoteCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbWord;
@property (weak, nonatomic) IBOutlet UILabel *lbKanji;
@property (weak, nonatomic) IBOutlet UIButton *btnSound;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeightTopView;
@property (weak, nonatomic) IBOutlet UITableView *tbvGrammar;
@property (strong, nonatomic) NSMutableArray *listMeaning;
@property (strong, nonatomic) NSMutableArray *listExamples;
@property (strong, nonatomic) NSMutableArray *listNote;
@end

@implementation DetailGrammarController

# pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].getDetailDelegate = self;
    [DataManager shared].searchWordDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Helper Method

- (void)config {
    
    self.listExamples = [[NSMutableArray alloc] init];
    self.listMeaning = [[NSMutableArray alloc] init];
    self.listNote = [[NSMutableArray alloc] init];
    
    // set layer
    [Utilities circleButton:self.btnSound];
    
    [self handleNote];
    
    if (self.aGrammar) {
        [self handleGrammar];
    } else if (self.aVocabulary) {
        [self handleVocabulary];
    }
}

- (IBAction)btnSound:(id)sender {
    if (self.aGrammar) {
        [[Sound shared] playSoundWithText:self.aGrammar.name];
    } else if (self.aVocabulary) {
        [[Sound shared] playSoundWithText:self.aVocabulary.nameHiragana];
    }
    
}

- (void)requestMeaning:(NSString *)name {
    ProgressBarShowLoading(kLoading);
    NSString *searchUrl = [NSString stringWithFormat:@"%@%@",kSearchUrl,name];
    [[DataManager shared] searchVocabularyWithUrl:searchUrl];

}

# pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kSectionMeaning: {
            MeaningCell  *meaningCell = [tableView dequeueReusableCellWithIdentifier:kMeaningCellIdentifier];
            Vocabulary *voca = self.listMeaning[indexPath.row];
            NSAttributedString *attributeString = [Utilities convertStringToNSAttributeString:[voca.nameEnglish stringByAppendingString:kHTMLFontSize17]];
            CGRect rectMeaning= [Utilities getRectFromAttributedString:attributeString
                                                             withWidth:[[UIScreen mainScreen] bounds].size.width];
            
            return rectMeaning.size.height + meaningCell.lbStatus.frame.size.height + meaningCell.lbHiragana.frame.size.height + kConstantBetweenTwoTextMeaning;
        }
            break;
            
        case kSectionExample: {
            Grammar *objGrammar = self.listExamples[indexPath.row];
            CGRect rectCell = [Utilities getRectFromAttributedString:[Utilities convertStringToNSAttributeString:objGrammar.rawExample]
                                                           withWidth:[[UIScreen mainScreen] bounds].size.width];
            return rectCell.size.height + kConstantBetweenTwoTextExample;
        }
            break;
            
        case kSectionNote: {
            return kDefaultHeightRow;
        }
            break;
            
        default:
            return kDefaultHeightRow;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSectionDetailGrammar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kSectionMeaning:
            return self.listMeaning.count;
            break;
        
        case kSectionExample:
            return self.listExamples.count;
            break;
        
        case kSectionNote: {
            if (self.listNote.count > 0) {
                return self.listNote.count;
            } else {
                return 1;
            }
        }
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kSectionMeaning:
            return kMeaningTitle;
            break;
            
        case kSectionExample:
            return kExampleTitle;
            break;
            
        case kSectionNote:
            return kNoteTitle;
            break;
            
        default:
            return kEmpty;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case kSectionMeaning: {
            MeaningCell  *meaningCell = [tableView dequeueReusableCellWithIdentifier:kMeaningCellIdentifier];
            if(!meaningCell) { meaningCell = [[MeaningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMeaningCellIdentifier];}
            
            [meaningCell loadInformationMeaning:self.listMeaning[indexPath.row]];
            cell = meaningCell;
        }
            break;
            
        case kSectionExample: {
            ExampleCell  *exampleCell = [tableView dequeueReusableCellWithIdentifier:kExampleCellIdentifier];
            if(!exampleCell) { exampleCell = [[ExampleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kExampleCellIdentifier];}
            
            Grammar *objGrammar = self.listExamples[indexPath.row];
            exampleCell.lbExample.attributedText = [Utilities convertStringToNSAttributeString:objGrammar.rawExample];
            cell = exampleCell;
        }
            break;
            
        case kSectionNote: {
            NoteCell  *noteCell = [tableView dequeueReusableCellWithIdentifier:kNoteIdentifier];
            noteCell.delegate = self;
            
            if(!noteCell) { noteCell = [[NoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNoteIdentifier];}
            
            if (self.listNote.count > 0) {
                Note *notes = self.listNote[indexPath.row];
                noteCell.aNote = notes;
                [noteCell loadInformation];
            } else {
                Note *notes = [Note new];
                notes.noteMessage = kAddNote;
                noteCell.aNote = notes;
                [noteCell loadInformation];
            }
            
            cell = noteCell;
        }
            break;
    }
    
    return cell;
}

# pragma mark Get Detail Delegate

- (void)getDetailGrammarAPISuccess:(NSData *)response {
    
    // Parse Data from HTML
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:response];
    NSArray *grammarNode = [tutorialsParser searchWithXPathQuery:kQueryDetailGrammar];
    NSString *finalString = kEmpty;
    
    for (int i = 0; i < grammarNode.count; i++) {
        TFHppleElement *element = grammarNode[i];
        finalString = [[element raw] stringByAppendingString:kHTMLFontSize17];
        
        Grammar *newGrammar = [Grammar new];
        newGrammar.rawExample = finalString;
        newGrammar.nameGrammarRelated = self.aGrammar.name;
        [newGrammar commit];
        [self.listExamples addObject:newGrammar];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{ // 2
        ProgressBarDismissLoading(kEmpty);
        [self reloadSectionDU:kSectionExample withRowAnimation:UITableViewRowAnimationNone];
    });
    
}


- (void)getDetailGrammarAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmpty);
}

#pragma mark - Search Word Delegate
- (void)searchWordAPISuccess:(NSData *)response {

    // Parse Data from HTML
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:response];
    NSArray *searchNode = [tutorialsParser searchWithXPathQuery:kQuerySearch];
    NSMutableArray *listWordSearch = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in searchNode) {
        
        Vocabulary *newVoca = [Vocabulary new];
        for (TFHppleElement *childElement  in element.children) {
            
            if ([[childElement tagName] isEqualToString:kDD]) {
                NSArray *spanPos = [childElement searchWithXPathQuery:kSpanPos];
                for (TFHppleElement *elementSpan in spanPos) {
                    newVoca.statusWord = [elementSpan content];
                }
                
            }
            if ([[childElement tagName] isEqualToString:kA]) {
                
                NSString *rawA = [childElement raw];
                NSDictionary *dictResponse = [Utilities parseRawSearchToDict:rawA];
                
                if (dictResponse.count > 0) {
                    newVoca.nameKanji = [Utilities convertString:[dictResponse objectForKey:kW]];
                    newVoca.nameHiragana = [Utilities convertString:[dictResponse objectForKey:kK]];
                    newVoca.nameEnglish = [Utilities convertString:[dictResponse objectForKey:kM]];
                    newVoca.read = [Utilities convertString:[dictResponse objectForKey:kR]];
                }
            }
            NSLog(@"%@", childElement);
        }
        
        if (self.aGrammar) {
            newVoca.nameVocabularyRelated = self.aGrammar.name;
        } else {
            newVoca.nameVocabularyRelated = self.aVocabulary.nameHiragana;
        }
        
        [newVoca commit];
        [listWordSearch addObject:newVoca];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{ // 2
        [self.listMeaning addObjectsFromArray: listWordSearch];
        [self reloadSectionDU:kSectionMeaning withRowAnimation:UITableViewRowAnimationNone];
        ProgressBarDismissLoading(kEmpty);
        
    });
    
}

- (void)searchWordAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmpty);
}

# pragma mark Handle Grammar - Vocabulary

/*
 *  Did select grammar
 */
- (void)handleGrammar {
    self.lbWord.text = self.aGrammar.name;
    self.csHeightTopView.constant = kHeightConstantGrammar;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSArray *listExampleLocal = [[DataAccess shared] listGrammarRelated:self.aGrammar.name];
        NSArray *listVocaLocal = [[DataAccess shared] listVocabularyRelated:self.aGrammar.name];
        
        // Vocabulary
        if (listVocaLocal.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                self.listMeaning = [listVocaLocal mutableCopy];
                [self.tbvGrammar reloadData];
            });
            
        } else {
            ProgressBarShowLoading(kLoading);
            [self requestMeaning:self.aGrammar.name];
        }
        
        // Grammar
        if (listExampleLocal.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                self.listExamples = [listExampleLocal mutableCopy];
                [self.tbvGrammar reloadData];
            });
            
        } else {
            ProgressBarShowLoading(kLoading);
            [[DataManager shared] getDetailGrammarWithUrl:self.aGrammar.href];
        }
    });
    
    [self reloadSectionDU:kSectionExample withRowAnimation:UITableViewRowAnimationNone];
    
}

/*
 *  Did select row vocabulary
 */
- (void)handleVocabulary {
    self.lbWord.text = self.aVocabulary.nameHiragana;
    self.lbKanji.text = [NSString stringWithFormat:@"Kanji: %@",self.aVocabulary.nameKanji];
    self.csHeightTopView.constant = kHeightConstantVocabulary;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        
        NSArray *listVocaLocal = [[DataAccess shared] listVocabularyRelated:self.aVocabulary.nameHiragana];
        
        if (listVocaLocal.count > 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.listMeaning = [listVocaLocal mutableCopy];
                [self.tbvGrammar reloadData];
            });
            
        } else {
            ProgressBarShowLoading(kLoading);
            [self requestMeaning:self.aVocabulary.nameHiragana];
        }
    });
    
    [self reloadSectionDU:kSectionMeaning withRowAnimation:UITableViewRowAnimationNone];
}

/*
 *  Did select note
 */
- (void)handleNote {
    [self.listNote removeAllObjects];
    NSArray *listNoteLocal = [[NSArray alloc] init];
    if (self.aGrammar) {
        listNoteLocal = [[DataAccess shared] listNoteRelated:self.aGrammar.name];
    } else if (self.aVocabulary) {
        listNoteLocal = [[DataAccess shared] listNoteRelated:self.aVocabulary.nameHiragana];
    }

    if (listNoteLocal.count > 0) {
        
        Note *note = [Note new];
        note.noteMessage = kAddNote;
        
        self.listNote = [listNoteLocal mutableCopy];
        [self.listNote addObject:note];
    } else {
        
    }
    
    [self reloadSectionDU:kSectionNote withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark Note Controller Delegate
- (void)dismissNote:(UIViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self handleNote];
}

- (void) reloadSectionDU:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tbvGrammar reloadSections:sectionToReload withRowAnimation:rowAnimation];
}

#pragma mark Note Cell Delegate
- (void)addNote {
    NoteController *noteController = InitStoryBoardWithIdentifier(kNoteControllerStoryBoarID);
    noteController.delegate = self;
    
    if (self.aGrammar) {
        noteController.nameRelate = self.aGrammar.name;
    } else if (self.aVocabulary) {
        noteController.nameRelate = self.aVocabulary.nameHiragana;
    }
    
    [self.tabBarController presentViewController:noteController animated:YES completion:nil];
}

- (void)removeNote:(Note *)noteRemove {
    
    [self.listNote removeObject:noteRemove];
    [noteRemove remove];
    [self reloadSectionDU:kSectionNote withRowAnimation:UITableViewRowAnimationNone];
}

- (void)editNote:(Note *)noteEdit {
    NoteController *noteController = InitStoryBoardWithIdentifier(kNoteControllerStoryBoarID);
    noteController.aNote = noteEdit;
    noteController.delegate = self;
    
    if (self.aGrammar) {
        noteController.nameRelate = self.aGrammar.name;
    } else if (self.aVocabulary) {
        noteController.nameRelate = self.aVocabulary.nameHiragana;
    }
    
    [self.tabBarController presentViewController:noteController animated:YES completion:nil];
}

@end
