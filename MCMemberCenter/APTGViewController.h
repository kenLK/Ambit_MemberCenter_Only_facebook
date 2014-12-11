//
//  BundlingViewController.h
//  MCMemberCenter
//
//  Created by Ken on 2014/10/13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MC/MCFramework.h>
@interface APTGViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary *resultJason;

@property (nonatomic, retain) UIWebView *mWebView;
@end
