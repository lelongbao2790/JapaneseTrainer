//
//  DataAccess.m
//  JLPTTrainer
//
//  Created by Bao (Brian) L. LE on 5/31/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "DataAccess.h"

@implementation DataAccess

//*****************************************************************************
#pragma mark -
#pragma mark ** Singleton object **
+ (DataAccess *)shared {
    static dispatch_once_t once;
    static DataAccess *share;
    dispatch_once(&once, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (NSArray *)listVocabularyByLevel:(NSInteger)level {
    DBResultSet* r = [[[Vocabulary query]
                        whereWithFormat:@"level = %d", (int)level]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listVocabularyRelated:(NSString *)nameRelated {
    DBResultSet* r = [[[Vocabulary query]
                       whereWithFormat:@"nameVocabularyRelated = %@", nameRelated]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listGrammarRelated:(NSString *)nameRelated {
    DBResultSet* r = [[[Grammar query]
                       whereWithFormat:@"nameGrammarRelated = %@", nameRelated]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listKanjiRelated:(NSString *)nameRelated {
    DBResultSet* r = [[[Kanji query]
                       whereWithFormat:@"nameKanjiRelated = %@", nameRelated]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listNoteRelated:(NSString *)nameRelated {
    DBResultSet* r = [[[Note query]
                       whereWithFormat:@"nameRelate = %@", nameRelated]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listBookMarkVocabulary {
    DBResultSet* r = [[[Vocabulary query]
                       whereWithFormat:@"isBookmark = 1"]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listBookMarkGrammar {
    DBResultSet* r = [[[Grammar query]
                       whereWithFormat:@"isBookmark = 1"]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listBookMarkKanji {
    DBResultSet* r = [[[Kanji query]
                       whereWithFormat:@"isBookmark = 1"]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listGrammarByLevel:(NSInteger)level {
    DBResultSet* r = [[[Grammar query]
                       whereWithFormat:@"level = %d", (int)level]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

- (NSArray *)listKanjiByLevel:(NSInteger)level {
    DBResultSet* r = [[[Kanji query]
                       whereWithFormat:@"level = %d", (int)level]
                      fetch];
    
    if (r.count > 0) {
        return r;
    }
    else
        return nil;
}

@end
