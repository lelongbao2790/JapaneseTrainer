//
//  Kanji.h
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/30/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kanji : DBObject

@property (strong, nonatomic) NSString *kanjiWord;
@property (strong, nonatomic) NSString *onyomi;
@property (strong, nonatomic) NSString *kunyomi;
@property (strong, nonatomic) NSString *englishMeaning;
@end
