//
//  SettingController.m
//  JLPTTrainer
//
//  Created by Bao (Brian) L. LE on 6/13/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()
@property (weak, nonatomic) IBOutlet UISlider *slideVolumn;
@property (weak, nonatomic) IBOutlet UILabel *lbNameExample;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDelete:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSlideVolume:(id)sender {
}

- (IBAction)btnSave:(id)sender {
    [Sound shared].speedValue = self.slideVolumn.value;
    [Utilities showiToastMessage:@"Sound saved successfully"];
}

- (IBAction)btnSound:(id)sender {
    [[Sound shared] playSoundWithText:self.lbNameExample.text];
}

@end
