//
//  Utilities.h
//  JapaneseTrainer
//
//  Created by Bao (Brian) L. LE on 5/25/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (void)removeBlankFooterTableView:(nonnull UITableView *)tbv;
+ (nonnull NSString *)removeAlphabeFromJapaneseString:(nonnull NSString *)original;
/*
 * Detect is search or not
 */
+ (BOOL)isSearchController:(nonnull UISearchController *)searchController;

/*
 * Convert Object String
 */
+ (nonnull NSString *)convertString:(nonnull NSString *)strWord;

+ (nonnull NSDictionary *)parseRawSearchToDict:(nonnull NSString *)original;
+ (void)circleButton:(UIView *)btn;

+ (void)borderView:(UIView *)btn;

+ (NSAttributedString *)convertStringToNSAttributeString:(NSString *)original;
@end
