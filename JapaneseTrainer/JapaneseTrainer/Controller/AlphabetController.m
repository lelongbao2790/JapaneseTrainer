//
//  AlphabetController.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/23/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "AlphabetController.h"
#import "CustomWritingLayout.h"

@interface AlphabetController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *listWriting;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segWriting;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionWriting;
@end

@implementation AlphabetController

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
    [self handleContent:kHiragana];
}

# pragma mark  Helper Method

- (void)config {
    self.listWriting = [[NSMutableArray alloc] init];
    self.collectionWriting.collectionViewLayout = [[CustomWritingLayout alloc] init];
    [self.collectionWriting registerClass:[WritingCell class] forCellWithReuseIdentifier:kWritingCell];
    [self.collectionWriting reloadData];
}

- (void)handleContent:(NSString *)key {
    [self.listWriting removeAllObjects];
    NSDictionary *dTmp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kNamePlist ofType:kPlist]];
    NSArray *listTmp = [dTmp valueForKey:key];
    
    for (int i=0; i<listTmp.count; i++) {
        NSDictionary *dictI = listTmp[i];
        [self.listWriting addObject:dictI];
    }
    
    [self.collectionWriting reloadData];
}

- (IBAction)btnSeg:(id)sender {
    
    // Switch level
    switch (self.segWriting.selectedSegmentIndex) {
            
        case kHiraganaSeg:
          [self handleContent:kHiragana];
          break;
            
        case kKataganaSeg:
          [self handleContent:kKatagana];
          break;
            
        default:
            [self handleContent:kHiragana];
            break;
    }
    
}

# pragma mark  UICollection Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listWriting.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    WritingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWritingCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dictCell = self.listWriting[indexPath.row];
    
    NSString *hiraganaText = [dictCell objectForKey:kHiraganaKey];
    
    if (![hiraganaText isEqualToString:kStringEmpty]) {
        cell.lbTitle.text = hiraganaText;
        cell.lbRomanji.text = [dictCell objectForKey:kRomanjiKey];
    } else {
        cell.lbTitle.text = kEmpty;
        cell.lbRomanji.text = kEmpty;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictCell = self.listWriting[indexPath.row];
    NSString *hiraganaText = [dictCell objectForKey:kHiraganaKey];
    
    if (![hiraganaText isEqualToString:kStringEmpty]) {
        [[Sound shared] playSoundWithText:[dictCell objectForKey:kHiraganaKey]];
    }
    
}

@end
