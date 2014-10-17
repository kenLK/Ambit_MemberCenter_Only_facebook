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

@property (strong, nonatomic) IBOutlet FBLoginView *fbLoginView;


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
    
//    MCFacebook* mcf = [[MCFacebook alloc] initWithNibName:@"" bundle:nil];
    //[mcf requestUserInfo];

//    __block NSDictionary *user = nil;
//  取得facebook用戶資料
    [mcFacebook getUserInfo:@""
                    success:^(id responseObject) {
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
//                                    [rootViewController presentViewController:reg animated:YES completion:nil];
                                    
//                                     presentViewController:animated:completion:
                                    
                                }
                                if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-430"]) {
                                    
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>-430>>>>>>>>>>>>>>");
                                    
                                    BundlingViewController* reg = [[BundlingViewController alloc] init];
                                    
                                    
                                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:EMAIL, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_FACEBOOK,@"LOGIN_TYPE",OPEN_UID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                    
                                    [reg setResultJason:dict];
                                    
                                    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                    [rootViewController presentViewController:reg animated:YES completion:^{}];
                                    
                                    
                                }
                            } failure:^(NSError *error) {
                                
                            }];
                            
                            /*
                            if (mcl.loginResultJSON) {
                                
                                MCLogger(@"returnJason>>>%@",[mcl.loginResultJSON objectForKey:@"returnCode"]);
                                NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[returnJason dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                                if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-429"]) {
                                    
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>-429>>>>>>>>>>>>>>");
                                }
                                if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-430"]) {
                                    
                                    MCLogger(@"FBLogin>>>>>>>>>>>>>-430>>>>>>>>>>>>>>");
                                }
                            }*/
                        }
                    }
                    failure:^(NSError *error) {
                     
                    }];

    
    
    MCLogger(@"FBLogin>>>>>>>>>>>>>END>>>>>>>>>>>>>>");
}
    
-(void)publishFacebook{
        NSMutableDictionary *postParams2= [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"haberLink", @"link",
                                           @"abc.com", @"name",
                                           @"title", @"caption",
                                           @"desc", @"description",
                                           nil];
        
        [FBRequestConnection
         startWithGraphPath:@"me/feed"
         parameters:postParams2
         HTTPMethod:@"POST"
         completionHandler:^(FBRequestConnection *connection,
                             id result,
                             NSError *error) {
             NSString *alertText;
             if (error) {
                 alertText = [NSString stringWithFormat:
                              @"error: domain = %@, code = %d",
                              error.domain, error.code];
             } else {
                 alertText = [NSString stringWithFormat: @"Shared Facebook"];
                 
                 
                 
                 [[[UIAlertView alloc] initWithTitle:@"Shared Facebook"
                                             message:alertText
                                            delegate:self
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil]
                  show];
                 
             }
         }];
}
- (IBAction)login:(id)sender {
    
    MCLogger(@"returnJason>>>%@",mcFacebook.facebookID);
    MCLogger(@"returnJason>>>%@",mcFacebook.email);

    AmbitLoginViewController* reg = [[AmbitLoginViewController alloc] init];
    
    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
    [rootViewController presentViewController:reg animated:YES completion:^{}];
    
}
- (IBAction)test:(id)sender {
    
    
    AmbitRegisterViewController* reg = [[AmbitRegisterViewController alloc] init];
    
    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
    [rootViewController presentViewController:reg animated:YES completion:^{}];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([[segue identifier] isEqualToString:@"register"]) {
        
        
        //將page2設定成Storyboard Segue的目標UIViewController
        id page2 = segue.destinationViewController;
        
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:[self.objectID dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        [page2 setResultJason:resultJSON];
//        page2 setResultJason:<#(NSDictionary *)#>
        RegisterViewController *login = [segue destinationViewController];
    }
}


@end
