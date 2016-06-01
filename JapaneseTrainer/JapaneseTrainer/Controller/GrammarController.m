//
//  GrammarController.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/23/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "GrammarController.h"

@interface GrammarController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *listGrammar;
@property (weak, nonatomic) IBOutlet UITableView *tbvGrammar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnSegLevel;

@end

@implementation GrammarController

# pragma mark Life Cycle

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
    [DataManager shared].getListGrammarDelegate = self;
}

# pragma mark Helper Method

- (void)config {
    
    self.listGrammar = [[NSMutableArray alloc] init];
    [Utilities removeBlankFooterTableView:self.tbvGrammar];
    [self btnGrammar:nil];
}

- (IBAction)btnGrammar:(id)sender {
    
    [self.listGrammar removeAllObjects];
    [self.tbvGrammar reloadData];
    
    NSDictionary *dTmp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kNamePlist ofType:kPlist]];
    NSArray *listTmp = [dTmp valueForKey:kObjects];
    NSMutableArray *listObjects = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictItem in listTmp) {
        if ([[dictItem objectForKey:kName] isEqualToString:kGrammar]) {
            [listObjects addObjectsFromArray:[dictItem valueForKey:kObjects]];
            break;
        }
    }
    
    // Switch level
    switch (self.btnSegLevel.selectedSegmentIndex) {
            
        case kSegLevelN1: {
            [self requestGetVocabulary:listObjects andLevel:kVocabularyLevelN2];
        }
            break;
            
        case kSegLevelN2: {
            [self requestGetVocabulary:listObjects andLevel:kVocabularyLevelN2];
        }
            break;
            
        case kSegLevelN3: {
            [self requestGetVocabulary:listObjects andLevel:kVocabularyLevelN3];
        }
            break;
            
        case kSegLevelN4: {
            [self requestGetVocabulary:listObjects andLevel:kVocabularyLevelN4];
        }
            break;
            
        case kSegLevelN5: {
            [self requestGetVocabulary:listObjects andLevel:kVocabularyLevelN5];
        }
            break;
            
        default:
            break;
    }
}

- (void)requestGetVocabulary:(NSArray *)listVoca andLevel:(NSString *)level {
    [self.listGrammar removeAllObjects];
    [self.tbvGrammar reloadData];
    
    NSArray *listVocabularyLocal = [[NSArray alloc] init];
    listVocabularyLocal = [[DataAccess shared] listGrammarByLevel:self.btnSegLevel.selectedSegmentIndex];
    if (listVocabularyLocal.count > 0) {
        self.listGrammar = [listVocabularyLocal mutableCopy];
        [self.tbvGrammar reloadData];
    } else {
        for (NSDictionary *dictVoca in listVoca) {
            NSString *name = [dictVoca objectForKey:kName];
            NSString *link = [dictVoca objectForKey:kLink];
            if ([name isEqualToString:level]) {
                ProgressBarShowLoading(kLoading);
                [[DataManager shared] getGrammarWithUrl:link];
                break;
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listGrammar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierGrammar forIndexPath:indexPath];
    Grammar *aGrammar = self.listGrammar[indexPath.row];
    cell.textLabel.text = aGrammar.name;
    cell.textLabel.font = [UIFont systemFontOfSize:19.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailGrammarController *detailGrammar = InitStoryBoardWithIdentifier(kDetailGrammarStoryBoardID);
    Grammar *aGrammar = self.listGrammar[indexPath.row];
    detailGrammar.aGrammar = aGrammar;
    if (aGrammar.rawExample.length < 1) {
        ProgressBarShowLoading(kLoading);
        [[DataManager shared] getDetailGrammarWithUrl:aGrammar.href];
    } 
    
    [self.navigationController pushViewController:detailGrammar animated:YES];
    
}

# pragma mark Get List Grammar
- (void)getListGrammarAPISuccess:(NSData *)response {
    ProgressBarDismissLoading(kEmpty);
    
    // Parse Data from HTML
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:response];
    NSArray *grammarNode = [tutorialsParser searchWithXPathQuery:kQueryListGrammar];
    NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in grammarNode) {
        Grammar *newGrammar = [Grammar new];
        newGrammar.name = [Utilities removeAlphabeFromJapaneseString:[[element firstChild] content]];
        newGrammar.href = [element objectForKey:kHref];
        newGrammar.level = self.btnSegLevel.selectedSegmentIndex;
        [newGrammar commit];
        [newTutorials addObject:newGrammar];
        NSLog(@"%@",newGrammar.name);
    }
    
    self.listGrammar = [newTutorials mutableCopy];
    [self.tbvGrammar reloadData];
}

- (void)getListGrammarAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmpty);
}


@end
