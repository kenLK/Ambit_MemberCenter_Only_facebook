//
//  RegisterViewController.h
//  MCMemberCenter
//
//  Created by Ken on 2014/10/8.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MC/MCFramework.h>
@interface RegisterViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *resultJason;


@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *test;

@end
