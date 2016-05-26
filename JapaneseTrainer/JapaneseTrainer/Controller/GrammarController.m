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
    
}

# pragma mark Helper Method

- (void)config {
    
    self.listGrammar = [[NSMutableArray alloc] init];
    [Utilities removeBlankFooterTableView:self.tbvGrammar];
    [self handleContent];
}

- (void)handleContent {
    [self.listGrammar removeAllObjects];
    NSDictionary *dTmp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kNamePlist ofType:kPlist]];
    NSArray *listTmp = [dTmp valueForKey:kObjects];
    for (NSDictionary *dictItem in listTmp) {
        if ([[dictItem objectForKey:kName] isEqualToString:kGrammar]) {
            [self.listGrammar addObjectsFromArray:[dictItem valueForKey:kObjects]];
            break;
        }
    }
    [self.tbvGrammar reloadData];
        
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
    cell.textLabel.text = [self.listGrammar[indexPath.row] objectForKey:kName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ListGrammarController *listGrammarController = InitStoryBoardWithIdentifier(kListGrammarLevelStoryBoardID);
    listGrammarController.linkLevel = [self.listGrammar[indexPath.row] objectForKey:kLink];
    listGrammarController.title = [self.listGrammar[indexPath.row] objectForKey:kName];
    [self.navigationController pushViewController:listGrammarController animated:YES];
    
}


@end
