//
//  Enumeration.h
//  HDOnline
//
//  Created by Bao (Brian) L. LE on 5/6/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#ifndef Enumeration_h
#define Enumeration_h

typedef NS_ENUM(NSInteger, VocabularyLevel) {

    kSegLevelN1 = 0,
    kSegLevelN2 = 1,
    kSegLevelN3 = 2,
    kSegLevelN4 = 3,
    kSegLevelN5 = 4,
};

typedef NS_ENUM(NSInteger, DetailViewText) {
    
    kHeightConstantGrammar = 60,
    kHeightConstantVocabulary = 95,
};

typedef NS_ENUM(NSInteger, WritingSeg) {
    
    kHiraganaSeg = 0,
    kKataganaSeg = 1,
    kKanjiSeg = 2,
    kTopConstantCollectionDefault = 0,
    kTopConstantCollectionKanji = 37,

};

#endif /* Enumeration_h */
