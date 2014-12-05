//
//  ViewController.h
//  MCMemberCenter
//
//  Created by Ken on 2014/10/6.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MC/MCFramework.h>
#import "RegisterViewController.h"
#import "OpenIDBundlingViewController.h"
#import "AmbitLoginViewController.h"
#import "AmbitRegisterViewController.h"
#import "AppDelegate.h"

#import <Accounts/Accounts.h>
#import <Accounts/AccountsDefines.h>
#import <Social/Social.h>

@interface ViewController : UIViewController<FBLoginViewDelegate,UIWebViewDelegate>
//UIApplicationDelegate,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *test;

@property (nonatomic, retain) UIWebView *mWebView;
//@property (strong, nonatomic) NSDictionary *userProfile;

- (void)loadYahooUserProfile:(NSMutableDictionary *)params;
@end

