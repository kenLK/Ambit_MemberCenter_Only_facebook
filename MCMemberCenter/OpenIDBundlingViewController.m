//
//  OpenIDBundlingViewController.m
//  MCMemberCenter
//
//  Created by Ken on 2014/10/21.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "OpenIDBundlingViewController.h"

@interface OpenIDBundlingViewController (){
    MCLogin* page;
}

@end

@implementation OpenIDBundlingViewController
@synthesize mWebView,resultJason,LOGIN_TYPE;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MCCONFIG" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    //進入綁定流程
    //                                    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"bundlingSDKURL"]];
    //                                    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //                                    [self.mWebView loadRequest:requestObj];
    //                                    self.mWebView.delegate = self;
    //                                    [self.view addSubview:self.mWebView];
    
    
    CGRect webFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.mWebView = [[UIWebView alloc] initWithFrame:webFrame];
    //    page = [[MCLogin alloc] init];
    //                                    page = [[MCLogin alloc] initWithWebView:self.mWebView toUrl:[dict objectForKey:@"bundlingSDKURL"]];
    MCLogger(@"webview>>>>>>%@",[dict objectForKey:@"bundlingPasswordSDKURL"]);
    NSString* bundlingSDKURL = (NSString*)[dict objectForKey:@"bundlingPasswordSDKURL"];
    /*
     ?SDK=IOS
     &VALID_STR=NzFmODM3MTg3MTNmMGFjMjdmODcxYmU5MDllNzRjNTgxNzM5NGQ0Zg--
     &LOGIN_TYPE=FACEBOOK
     &LOGIN_UID=915405488473664
     &CHECK_DATE=2014101223050582
     &ACCOUNT_TYPE=EMAIL
     &ACCOUNT=ken_wulk@hotmail.com
     */
    
    NSString *aLOGIN_TYPE = LOGIN_TYPE_FACEBOOK;
    
    if ([@"Yahoo"isEqualToString:LOGIN_TYPE]) {
        aLOGIN_TYPE = LOGIN_TYPE_YAHOO;
        NSLog(@"aLOGIN_TYPE %@", aLOGIN_TYPE);
    }
    
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"?SDK=IOS"];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&VALID_STR=%@",[resultJason objectForKey:@"VALID_STR"]];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&LOGIN_TYPE=%@",aLOGIN_TYPE];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&LOGIN_UID=%@",[resultJason objectForKey:@"LOGIN_UID"]];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&CHECK_DATE=%@",[resultJason objectForKey:@"CHECK_DATE"]];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&ACCOUNT_TYPE=EMAIL"];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&ACCOUNT=%@",[resultJason objectForKey:@"EMAIL"]];
    
    page = [[MCLogin alloc] initOpenIDDuplicate:self.mWebView toURL:bundlingSDKURL];
    //                                    page = [[MCLogin alloc] initWithWebView:self.web forState:MCUserBundling ];
    MCLogger(@"webview");
    self.mWebView.delegate = self;
    MCLogger(@"webview");
    [self.view addSubview:self.mWebView];
    MCLogger(@"webview");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL result =  [page shouldStartLoadWithRequest:request navigationType:navigationType];
    
    if ([page getLoginResult]) {
        MCLogger(@"getLoginResult: %@", [page getLoginResult]?@"YES":@"NO");
        NSUserDefaults* userPrefs = [NSUserDefaults standardUserDefaults];
        
        MCLogger(@"resultJason>>>>>>>>>%@>>>>>>>>", [userPrefs objectForKey:@"returnJason"]);
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    return result;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
