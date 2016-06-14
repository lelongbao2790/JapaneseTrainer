//
//  AmobiVideoAd.h
//  AmobiSDKV2.1
//
//  Created by LieuBB on 9/16/14.
//  Copyright (c) 2014 Amobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmobiVideoAd : UIView
-(void)prepare;
-(void)setDelegate:(id)_delegate;
-(void)playVideo:(UIViewController*)rootViewController;
@end

@protocol AmbVideoAdDelegate <NSObject>
@optional
- (void) onAdAvailable:(AmobiVideoAd*) adView;
- (void) onAdStarted:(AmobiVideoAd*) adView;
- (void) onAdFinished:(AmobiVideoAd*) adView;
- (void) onPrepareError:(AmobiVideoAd*) adView;
@end
