//
//  BundlingViewController.m
//  MCMemberCenter
//
//  Created by Ken on 2014/10/13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "BundlingViewController.h"

@interface BundlingViewController (){
    MCLogin* page;
}

@end

@implementation BundlingViewController
@synthesize mWebView,resultJason;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MCCONFIG" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    //進入綁定流程
    
    CGRect webFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.mWebView = [[UIWebView alloc] initWithFrame:webFrame];
//    page = [[MCLogin alloc] init];
    //                                    page = [[MCLogin alloc] initWithWebView:self.mWebView toUrl:[dict objectForKey:@"bundlingSDKURL"]];
    MCLogger(@"webview>>>>>>%@",[dict objectForKey:@"bundlingSDKURL"]);
    NSString* bundlingSDKURL = (NSString*)[dict objectForKey:@"bundlingSDKURL"];

    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"?SDK=IOS"];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&ACCOUNT_TYPE=%@",[resultJason objectForKey:@"ACCOUNT_TYPE"]];
    bundlingSDKURL=[bundlingSDKURL stringByAppendingFormat:@"&ACCOUNT=%@",[resultJason objectForKey:@"EMAIL"]];
    
    page = [[MCLogin alloc] initBasicDuplicate:self.mWebView toURL:bundlingSDKURL];
  
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

        MCLogger(@"resultJason>>>>>>>>>%@>>>>>>>>", [userPrefs objectForKey:@"bundlingJason"]);
        
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
