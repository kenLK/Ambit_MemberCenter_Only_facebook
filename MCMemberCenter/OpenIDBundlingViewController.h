//
//  OpenIDBundlingViewController.h
//  MCMemberCenter
//
//  Created by Ken on 2014/10/21.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MC/MCFramework.h>
@interface OpenIDBundlingViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary *resultJason;

@property (nonatomic, retain) UIWebView *mWebView;

@property (strong, nonatomic) IBOutlet NSString *LOGIN_TYPE;

@end
