//
//  KanjiController.h
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/30/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KanjiControllerDelegate;
@interface KanjiController : UIViewController
@property (weak, nonatomic) id<KanjiControllerDelegate> delegate;
@property (strong, nonatomic) Kanji *word;

@end

@protocol KanjiControllerDelegate<NSObject>
- (void)dismissController:(UIViewController *)controller;
@end