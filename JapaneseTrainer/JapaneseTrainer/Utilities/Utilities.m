//
//  Utilities.m
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/25/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities


+ (void)removeBlankFooterTableView:(nonnull UITableView *)tbv {
    tbv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tbv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

+ (nonnull NSString *)removeAlphabeFromJapaneseString:(nonnull NSString *)original {
    if ([original isEqualToString:kStringEmpty]) {
        return kEmpty;
    } else {
       return [getRegex(kRegExAZ) stringByReplacingMatchesInString:original options:0 range:NSMakeRange(0, [original length]) withTemplate:kEmpty]; 
    }
    
}

/*
 * Detect is search or not
 */
+ (BOOL)isSearchController:(nonnull UISearchController *)searchController {
    if (![searchController.searchBar.text isEqualToString:kEmpty]) {
        return YES;
    } else {
        return NO;
    }
}

/*
 * Convert Object String
 */
+ (nonnull NSString *)convertString:(nonnull NSString *)strWord {
    
    if (strWord.length > 0) {
        return strWord;
    } else {
        return kEmpty;
    }

}

+ (nonnull NSDictionary *)parseRawSearchToDict:(nonnull NSString *)original {
    original = [original stringByReplacingOccurrencesOfString:kFirstRawSearchReplace withString:kEmpty];
    original = [original stringByReplacingOccurrencesOfString:kSecondRawSearchReplace withString:kEmpty];
    original = [original stringByConvertingHTMLToPlainText];
    original = [original stringByReplacingOccurrencesOfString:kUnknownCharater1 withString:kEmpty];
    
    NSArray *objects = [original componentsSeparatedByString:@"',"];
    NSMutableDictionary *dictResponse = [[NSMutableDictionary alloc] init];
    for (NSString *objString in objects) {
        NSArray *arrayKeyValue = [objString componentsSeparatedByString:@":"];
        if (arrayKeyValue.count > 0) {
            NSString *key = arrayKeyValue[0];
            NSString *value = [arrayKeyValue[1] stringByReplacingOccurrencesOfString:kUnknownCharater2 withString:kEmpty];
            [dictResponse setObject:value forKey:key];
        }
    }
    return dictResponse;
}

+ (void)circleButton:(UIButton *)btn {
    btn.layer.cornerRadius = btn.frame.size.height / 2;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    btn.layer.borderWidth = 1.0;
}

@end
