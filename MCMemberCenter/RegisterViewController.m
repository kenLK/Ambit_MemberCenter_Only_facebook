//
//  RegisterViewController.m
//  MCMemberCenter
//
//  Created by Ken on 2014/10/8.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize resultJason,email,phone,password,test;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 120.0, 20.0)];
    [titleLabel setText:@"email"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:titleLabel];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(100, 50, 320.0, 20.0)];
    email.borderStyle = UITextBorderStyleRoundedRect;
//    [inputText setText:[content objectAtIndex:MPItemTitle]];
    [email setFont:[UIFont boldSystemFontOfSize:20]];
    
    email.delegate = self;
    [self.view addSubview:email];
    
    
    UILabel *titleLabelPhone = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 120.0, 20.0)];
    [titleLabelPhone setText:@"phone"];
    [titleLabelPhone setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:titleLabelPhone];
    
    UITextField *inputTextPhone = [[UITextField alloc] initWithFrame:CGRectMake(100, 80, 320.0, 20.0)];
    inputTextPhone.borderStyle = UITextBorderStyleRoundedRect;
    //    [inputText setText:[content objectAtIndex:MPItemTitle]];
    [inputTextPhone setFont:[UIFont boldSystemFontOfSize:20]];
    inputTextPhone.delegate=self;
    [self.view addSubview:inputTextPhone];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button.frame = CGRectMake(self.view.frame.size.width/2.0, 320, 50, 20);
    [button setTitle:@"close" forState:UIControlStateNormal];
    
//    [button setBackgroundImage:nor forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:button];
    
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    submitButton.frame = CGRectMake(self.view.frame.size.width/2.0, 380, 50, 20);
    [submitButton setTitle:@"submit" forState:UIControlStateNormal];
    
    //    [button setBackgroundImage:nor forState:UIControlStateNormal];
    
    [submitButton addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:submitButton];
    
    NSLog(@"%@",[resultJason objectForKey:@"returnCode"]);
    NSLog(@"%@",[resultJason objectForKey:@"VALID_STR"]);
    NSLog(@"%@",[resultJason objectForKey:@"CHECK_DATE"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)close{
    MCLogger(@"INTO >>>>>> CLOSE ");
    /*if (self.mView) {
        [self.mView removeFromSuperview];
    }*/
//    [self dismissModalViewControllerAnimated:YES completion:^(void){}];
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];

    MCLogger(@"END >>>>>> CLOSE ");
}


-(void)submitData{
    MCLogger(@"INTO >>>>>> submitData ");
    /*if (self.mView) {
     [self.mView removeFromSuperview];
     }*/
    //    [self dismissModalViewControllerAnimated:YES completion:^(void){}];
    MCLogin* mcl = [[MCLogin alloc] init];
//    mcl RegisterAmbitUser:<#(NSString *)#> openUID:<#(NSString *)#> login_type:<#(NSString *)#> sysID:<#(NSString *)#>
    
    
//    NSString* returnCode = [resultJason objectForKey:@"returnCode"];
//    NSString* VALID_STR = [resultJason objectForKey:@"VALID_STR"];
//    NSString* CHECK_DATE = [resultJason objectForKey:@"CHECK_DATE"];
//    NSString* VALID_EMAIL_STR = [resultJason objectForKey:@"VALID_EMAIL_STR"];
//    NSString* returnCode = [resultJason objectForKey:@"returnCode"];
//    [resultJason setValue:[self email].text forKey:@"EMAIL"];
    [resultJason setValue:[self phone].text forKey:@"PHONE"];
    
    for(NSString *key in [resultJason allKeys]) {
        NSLog(@"%@",[resultJason objectForKey:key]);
    }
    
    
    NSString* returnJason = [mcl RegisterAmbitUserInfoViaOpenID:LOGIN_TYPE_FACEBOOK registerValue:resultJason];
    
    // dismiss
    MCLogger(@"%@",[self email].text);
    MCLogger(@"%@",returnJason);
    MCLogger(@"END >>>>>> submitData ");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
