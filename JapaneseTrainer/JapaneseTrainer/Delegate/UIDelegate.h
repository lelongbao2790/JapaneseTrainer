//
//  UIDelegate.h
//  HDOnline
//
//  Created by Bao (Brian) L. LE on 5/9/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#ifndef UIDelegate_h
#define UIDelegate_h
#import <Foundation/Foundation.h>

/*
 * Login Delegate
 */
@protocol LoginDelegate
@optional
-(void) loginAPISuccess:(NSString *)accessToken;
-(void) loginAPIFail:(NSString *)resultMessage;
@end

/*
 * Get Movie Delegate
 */
@protocol GetMovieDelegate
@optional
-(void) getMovieAPISuccess:(NSDictionary *)response;
-(void) getMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Search Movie Delegate
 */
@protocol SearchMovieDelegate
@optional
-(void) searchMovieAPISuccess:(NSArray *)response;
-(void) searchMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Get Real ID Movie Delegate
 */
@protocol GetIDMovieDelegate
@optional
-(void) getIDMovieAPISuccess:(NSArray *)response;
-(void) getIdMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Get Link Play Movie Delegate
 */
@protocol GetLinkPlayMovieDelegate
@optional
-(void) getLinkPlayMovieAPISuccess:(NSArray *)response;
-(void) getLinkPlayMovieAPIFail:(NSString *)resultMessage;
@end

/*
 * Get List Category Delegate
 */
@protocol GetListCategoryDelegate
@optional
-(void) getListCategoryAPISuccess:(NSArray *)response;
-(void) getListCategoryAPIFail:(NSString *)resultMessage;
@end

/*
 * Get List New Delegate
 */
@protocol GetListNewDelegate
@optional
-(void) getListNewAPISuccess:(NSArray *)response withCurrentPage:(NSInteger)current;
-(void) getListNewAPIFail:(NSString *)resultMessage;
@end

#endif /* UIDelegate_h */
