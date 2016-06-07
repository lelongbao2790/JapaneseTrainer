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
