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
#import "BundlingViewController.h"
#import "AmbitLoginViewController.h"
#import "AmbitRegisterViewController.h"
@interface ViewController : UIViewController<FBLoginViewDelegate,UIWebViewDelegate>
//UIApplicationDelegate,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *test;

@property (nonatomic, retain) UIWebView *mWebView;
@end

