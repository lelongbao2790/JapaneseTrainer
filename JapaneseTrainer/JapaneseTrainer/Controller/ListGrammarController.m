//
//  ListGrammarController.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/25/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "ListGrammarController.h"

@interface ListGrammarController ()<UITableViewDelegate, UITableViewDataSource, GetListGrammarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvListGrammar;
@property (strong, nonatomic) NSMutableArray *listGrammar;
@end

@implementation ListGrammarController

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
    [Utilities removeBlankFooterTableView:self.tbvListGrammar];
    [self requestGetListGrammar];
    
}

- (void)requestGetListGrammar {
    if (self.linkLevel.length > 0) {
        ProgressBarShowLoading(kLoading);
        [[DataManager shared] getGrammarWithUrl:self.linkLevel];
    }
}

# pragma mark Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listGrammar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierListGrammar forIndexPath:indexPath];
    Grammar *aGrammar = self.listGrammar[indexPath.row];
    cell.textLabel.text = aGrammar.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailGrammarController *detailGrammar = InitStoryBoardWithIdentifier(kDetailGrammarStoryBoardID);
    Grammar *aGrammar = self.listGrammar[indexPath.row];
    detailGrammar.aGrammar = aGrammar;
    ProgressBarShowLoading(kLoading);
    [[DataManager shared] getDetailGrammarWithUrl:aGrammar.href];
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
        [newTutorials addObject:newGrammar];
        NSLog(@"%@",newGrammar.name);
    }
    
    self.listGrammar = [newTutorials mutableCopy];
    [self.tbvListGrammar reloadData];
}

- (void)getListGrammarAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmpty);
}


@end
