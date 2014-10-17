//
//  AmbitRegisterViewController.m
//  MCMemberCenter
//
//  Created by Ken on 2014/10/15.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "AmbitRegisterViewController.h"

@interface AmbitRegisterViewController ()

@end

@implementation AmbitRegisterViewController
@synthesize EMAIL,PHONE,USER_PASSWORD,USER_NAME,USER_TYPE,BRITH_DATE,SEX,ZIP,HSN_NM,TOWN_NM,ADDR,IDN_BAN,USER_NM,EMPLOYEE_NUMBER,ENG_NM,TERM_CHECK_FLAG,ENTERPRISE_CUSTOME,CALLING_COUNTRY_CODE;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.USER_PASSWORD.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)REGISTER:(id)sender {
    MCLogin* mcl =[[MCLogin alloc] init];
    
    NSDictionary *parameters = @{@"SYS_ID": @"OTT_ARDI",
                                 @"EMAIL": EMAIL.text,
                                 @"PHONE": PHONE.text,
                                 @"USER_PASSWORD": USER_PASSWORD.text,
                                 @"USER_NAME": USER_NAME.text,
                                 @"USER_TYPE": USER_TYPE.text,
                                 @"BRITH_DATE": BRITH_DATE.text,
                                 @"SEX": SEX.text,
                                 @"ZIP": ZIP.text,
                                 @"HSN_NM": HSN_NM.text,
                                 @"TOWN_NM": TOWN_NM.text,
                                 @"ADDR": ADDR.text,
                                 @"IDN_BAN": IDN_BAN.text,
                                 @"USER_NM": USER_NM.text,
                                 @"EMPLOYEE_NUMBER": EMPLOYEE_NUMBER.text,
                                 @"ENG_NM": ENG_NM.text,
                                 @"TERM_CHECK_FLAG": TERM_CHECK_FLAG.text,
                                 @"ENTERPRISE_CUSTOME": ENTERPRISE_CUSTOME.text,
                                 @"CALLING_COUNTRY_CODE": CALLING_COUNTRY_CODE.text};
    
    NSString* returnJason = [mcl RegisterAmbitUserInfoViaBasic:@"" registerValue:parameters];
    MCLogger(@"returnJason>>>>>>>%@",returnJason);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)close:(id)sender {
    MCLogger(@"INTO >>>>>> CLOSE ");
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MCLogger(@"END >>>>>> CLOSE ");
}

@end
