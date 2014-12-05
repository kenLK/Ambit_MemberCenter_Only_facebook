//
//  AmbitLoginViewController.m
//  MCMemberCenter
//
//  Created by Ken on 2014/10/15.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "AmbitLoginViewController.h"

@interface AmbitLoginViewController ()

@end

@implementation AmbitLoginViewController
@synthesize EMAIL,PHONE,PASSWORD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.PASSWORD.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LOGIN:(id)sender {
    MCLogin* mcl = [[MCLogin alloc] init];
    
    NSString* returnJson = @"";
    NSRange range = [EMAIL.text rangeOfString:@"@"];
    
    if (range.location == NSNotFound) {
        returnJson = [mcl GetAmbitUserInfoViaBase:PHONE.text userPassword:PASSWORD.text sysID:@"OTT_ARDI"];
    }else if(PHONE.text){
        returnJson = [mcl GetAmbitUserInfoViaBase:EMAIL.text userPassword:PASSWORD.text sysID:@"OTT_ARDI"];
    }else{
        
        MCLogger(@"please input account>>>>>");
    }
    NSData* genData = [returnJson dataUsingEncoding:NSUTF8StringEncoding];
    //        data = [data subdataWithRange:NSMakeRange(0, [data length] - 1)];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:genData options:kNilOptions error:nil];
    
     if ([[json objectForKey:@"returnCode"] isEqual:@"-430"]) {
         MCLogger(@"bundling");
    }
    
    
    MCLogger(@"returnJason>>>>>%@",json);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)CLOSE:(id)sender {
    MCLogger(@"INTO >>>>>> CLOSE ");
    /*if (self.mView) {
     [self.mView removeFromSuperview];
     }*/
    //    [self dismissModalViewControllerAnimated:YES completion:^(void){}];
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MCLogger(@"END >>>>>> CLOSE ");
}

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
@end
