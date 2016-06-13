//
//  AmobiAdView.h
//  AmobiSDKV2.1
//
//  Created by LieuBB on 7/8/14.
//  Copyright (c) 2014 Amobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmobiAdView.h"

typedef enum
{
    SizeFullScreen,
    Size300x250,
    Size320x50
} BannerSize;

@interface AmobiAdView : UIView

// public functions
- (id) initWithBannerSize:(BannerSize) bannerSize;
- (void) setDelegate:(id)_delegate;
- (void) loadAd;
- (void) hideBanner:(id)sender;
- (void) loadAdSize:(BannerSize)bannerSize;

@end

@protocol AmobiBannerDelegate <NSObject>
@optional
- (void) adViewLoadSuccess:(AmobiAdView*) amobiAdView;
- (void) adViewLoadError:(AmobiAdView*) amobiAdView;
- (void) adViewClose:(AmobiAdView*) amobiAdView;
@end
