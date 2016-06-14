//
//  HomeController.m
//  JLPTTrainer
//
//  Created by LE LONG VU on 6/12/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#import "HomeController.h"
#import <MessageUI/MessageUI.h>

@interface HomeController ()<MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, AmobiBannerDelegate, AmbVideoAdDelegate>

@property (strong, nonatomic) AmobiVideoAd  *videoAd;
@property (strong, nonatomic) AmobiAdView *adView;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kJLPTTitle;
}

- (void)viewDidAppear:(BOOL)animated {
    [AppDelegate share].navHomeController = (NavigationCustomController *)self.navigationController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnStart:(id)sender {
    
    [self initVideoAds];
}

- (IBAction)btnFeedback:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kFeedbackTitle
                                                    message:kMessageAlert
                                                   delegate:self
                                          cancelButtonTitle:kCancel
                                          otherButtonTitles:kOK, nil];
    [alert show];
}

- (IBAction)btnSetting:(id)sender {
    SettingController *setting = InitStoryBoardWithIdentifier(kSettingControllerStoryBoardID);
    [self presentViewController:setting animated:YES completion:nil];
}

- (IBAction)btnRate:(id)sender {
    
    NSString * appId = kAppID;
    NSString * theUrl = [NSString  stringWithFormat:kItune,appId];
    if ([[UIDevice currentDevice].systemVersion integerValue] > 6)
        theUrl = [NSString stringWithFormat:kItune7,appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle Feedback **

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked Cancel
    if (buttonIndex == 0) {
        [self feedBackAction:NO andAttach:nil];
    } else {
        // OK
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(originalImage == nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (originalImage) {
        [self feedBackAction:YES andAttach:originalImage];
    } else {
        [self feedBackAction:NO andAttach:nil];
    }
}


/*
 * Method show crash log
 */
- (void)feedBackAction:(BOOL)isAttach andAttach:(UIImage *)imageAttach {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:kFeedbackTitle];
        [mailViewController setToRecipients:@[kEmailAuthor]];
        NSString *htmlMsg = @"<html><body><p>Feedback JLPT Trainer</body></html>";
        [mailViewController setMessageBody:htmlMsg isHTML:YES];
        
        if (isAttach) {
            
            NSData *jpegData = UIImageJPEGRepresentation(imageAttach, 1.0);
            NSString *fileName = @"feedback";
            fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
            [mailViewController addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
            
        } else {
            
        }
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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

- (void)moveToHome {
    [Utilities changeRootViewToTabBar:[AppDelegate share].tabbar andView:nil isTabbar:YES];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Delegate Ads **
- (void)onAdAvailable:(AmobiVideoAd *)adView {
    ProgressBarDismissLoading(kEmpty);
    [self.videoAd playVideo:self.navigationController];
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
