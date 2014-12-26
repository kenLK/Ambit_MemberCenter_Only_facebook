//
//  ViewController.m
//  MCMemberCenter
//
//  Created by Ken on 2014/10/6.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    MCLogin* page;
}

@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) MCFacebook *mcFacebook;

@end

@implementation ViewController

@synthesize mcFacebook,mWebView;


- (id) init
{
    if (self = [super init])
    {
        // do your own initialisation here
    }
    return self;
}

- (void)viewDidLoad {
//    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Ask for basic permissions on login
//    [_fbLoginView setReadPermissions:@[@"public_profile"]];
//    [_fbLoginView setDelegate:self];
//    _objectID = nil;
    
    mcFacebook = [[MCFacebook alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)FBLogin:(id)sender {
    
    MCLogger(@"FBLogin>>>>>>>>>>>>>INTO>>>>>>>>>>>>>>");

//  取得facebook用戶資料
    [mcFacebook getUserInfoWithSuccess:^(id responseObject) {
                        NSDictionary *user = (NSDictionary*)responseObject;
                        
                        //  login MC
                        if (user) {
                            MCLogin* mcl = [[MCLogin alloc] init];
                            NSString* EMAIL = [user objectForKey:@"email"];
                            NSString* OPEN_UID = [user objectForKey:@"id"];
                            [mcl GetAmbitUserInfoViaOpenID:EMAIL
                                                   openUID:OPEN_UID
                                                login_type:LOGIN_TYPE_FACEBOOK
                                                     sysID:@"OTT_ARDI"
                            success:^(id responseObject) {
                                NSData* responseData = (NSData*)responseObject;
                                MCLogger(@"%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                                
                                
                                NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];

                                if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-429"]) {
                                    
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>-429>>>>>>>>>>>>>>");
                                    
                                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:EMAIL, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_FACEBOOK,@"LOGIN_TYPE",OPEN_UID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                    
                                    RegisterViewController* reg = [[RegisterViewController alloc] init];
                                    [reg setResultJason:dict];

                                    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                    [rootViewController presentViewController:reg animated:YES completion:^{}];

                                    
                                }
                                if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-430"]) {
                                    
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>-430>>>>>>>>>>>>>>");
                                    
                                    OpenIDBundlingViewController* reg = [[OpenIDBundlingViewController alloc] init];
                                    
                                    
                                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:EMAIL, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_FACEBOOK,@"LOGIN_TYPE",OPEN_UID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                    
                                    [reg setResultJason:dict];
                                    
                                    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                    [rootViewController presentViewController:reg animated:YES completion:^{}];
                                    
                                    
                                }
                            } failure:^(NSError *error) {
                                
                            }];
                            
                        }
                    }
                    failure:^(NSError *error) {
                     
                    }];
    MCLogger(@"FBLogin>>>>>>>>>>>>>END>>>>>>>>>>>>>>");
}
    




@end
