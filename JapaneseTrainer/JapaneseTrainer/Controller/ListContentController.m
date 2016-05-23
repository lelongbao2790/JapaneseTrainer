//
//  ListContentController.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/23/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "ListContentController.h"


@interface ListContentController ()

@property (strong, nonatomic) NSMutableArray *listContent;

@end

@implementation ListContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
}

- (void)viewWillAppear:(BOOL)animated {
    [self handleContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method
- (void)config {
    self.listContent = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)handleContent {
    NSDictionary *dTmp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kNamePlist ofType:kPlist]];
    NSArray *listTmp = [dTmp valueForKey:kObjects];
    
    UIViewController *parentController = [self parentViewController];
    if ([parentController isKindOfClass:[GrammarController class]]) {
        
        [self getListItem:listTmp withKey:kGrammar];
        
    } else if ([parentController isKindOfClass:[ListeningController class]]) {
        
         [self getListItem:listTmp withKey:kListening];
        
    } else if ([parentController isKindOfClass:[VocabularyController class]]) {
        
        [self getListItem:listTmp withKey:kVocabulary];
        
    } else if ([parentController isKindOfClass:[AlphabetController class]]) {
        
        [self getListItem:listTmp withKey:kWriting];
        
    }
    
}

- (void)getListItem:(NSArray *)list withKey:(NSString *)key {
    [self.listContent removeAllObjects];
    for (NSDictionary *dictItem in list) {
        if ([[dictItem objectForKey:kName] isEqualToString:key]) {
            [self.listContent addObjectsFromArray:[dictItem valueForKey:kObjects]];
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContentCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.listContent[indexPath.row] objectForKey:kName];
    
    return cell;
}


@end
