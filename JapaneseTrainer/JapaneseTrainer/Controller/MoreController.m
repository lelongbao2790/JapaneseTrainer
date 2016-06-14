//
//  MoreController.m
//  JLPTTrainer
//
//  Created by Bao (Brian) L. LE on 6/10/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "MoreController.h"
 #import <CoreData/NSFetchRequest.h>
 #import <CoreData/NSEntityDescription.h>
#import <MessageUI/MessageUI.h>

@interface MoreController ()<AmobiBannerDelegate, AmbVideoAdDelegate>

@property (strong, nonatomic) AmobiVideoAd  *videoAd;
@property (strong, nonatomic) AmobiAdView *adView;

@end

@implementation MoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnHistory:(id)sender {
}

- (IBAction)btnHome:(id)sender {
    [self initVideoAds];
}

- (void)moveToHome {
    [Utilities changeRootViewToTabBar:nil andView:[AppDelegate share].navHomeController isTabbar:NO];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Prepare Ads **
- (void)initVideoAds {
    ProgressBarShowLoading(kLoading);
    // Init video ad
    self.videoAd= [[AmobiVideoAd alloc] init];
    [self.videoAd setDelegate:self];
    [self.videoAd prepare];
}

- (void)initBannerAds {
    // Init banner ads
    self.adView =   [[AmobiAdView alloc] initWithBannerSize:SizeFullScreen ];
    [self.adView setDelegate:self];
    [self.view addSubview:self.adView];
    [self.adView loadAd];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Delegate Ads **
- (void)onAdAvailable:(AmobiVideoAd *)adView {
    ProgressBarDismissLoading(kEmpty);
    [self.videoAd playVideo:self.tabBarController];
}

- (void)onAdStarted:(AmobiVideoAd *)adView {
    ProgressBarDismissLoading(kEmpty);
}

- (void)onAdFinished:(AmobiVideoAd *)adView {
    ProgressBarDismissLoading(kEmpty);
    [self moveToHome];
}

- (void)onPrepareError:(AmobiVideoAd *)adView {
    [self initBannerAds];
}

/*
 * Banner Ads
 */
- (void)adViewClose:(AmobiAdView *)amobiAdView {
    [self.adView removeFromSuperview];
    ProgressBarDismissLoading(kEmpty);
    [self moveToHome];
}

- (void)adViewLoadError:(AmobiAdView *)amobiAdView {
    [self.adView removeFromSuperview];
    ProgressBarDismissLoading(kEmpty);
    [self moveToHome];
}

- (void)adViewLoadSuccess:(AmobiAdView *)amobiAdView {
    ProgressBarDismissLoading(kEmpty);
}



@end
