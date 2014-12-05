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
@property (strong, nonatomic) ACAccountStore *accountStore;//ACAccountStore
@property (assign) BOOL isGoogleLogin;
@property (assign) BOOL isTwitterLogin;
@property (assign) BOOL isSinaWeiboLogin;
@property (assign) BOOL isYahooLogin;
@property (assign) BOOL isWeixinLogin;//WEIXIN
@end

@implementation ViewController

@synthesize mcFacebook,mWebView,isGoogleLogin,isTwitterLogin,isSinaWeiboLogin,isWeixinLogin, isYahooLogin;


- (id) init
{
    if (self = [super init])
    {
        // do your own initialisation here
        isGoogleLogin = NO;
        isTwitterLogin = NO;
        isSinaWeiboLogin = NO;
        isWeixinLogin = NO;
        isYahooLogin = NO;
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
//                                    [rootViewController presentViewController:reg animated:YES completion:nil];
                                    
//                                     presentViewController:animated:completion:
                                    
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
- (IBAction)googlePlusLogin:(id)sender {
    /*MCGooglePlus* reg = [[MCGooglePlus alloc] init];

    [[self navigationController] pushViewController:reg animated:YES];
    */
    isGoogleLogin = YES;
    MCGooglePlus* reg = [[MCGooglePlus alloc] init];
 
    
    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
    [rootViewController presentViewController:reg animated:YES completion:^{}];
    
    MCLogger(@">>>>>END>>>>>>>");
    
    /*
    // create a group
    dispatch_group_t group = dispatch_group_create();
    // pair a dispatch_group_enter for each dispatch_group_leave
    dispatch_group_enter(group);     // pair 1 enter
    [self computeInBackground:1 completion:^{
        [self getGoogleUserLogin];
        //20141114
//        [[[UIApplication sharedApplication] keyWindow]addSubview:reg.view];
//        [[[UIApplication sharedApplication] keyWindow] insertSubview:self.view aboveSubview:reg.view];
        /*
        UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
        [rootViewController presentViewController:reg animated:YES completion:^{}];
        */
    /*    NSLog(@"1 done");
        dispatch_group_leave(group); // pair 1 leave
    }];
    
    
    // again... (and again...)
    dispatch_group_enter(group);     // pair 2 enter
    [self computeInBackground:2 completion:^{
        NSLog(@"2 done");
        dispatch_group_leave(group); // pair 2 leave
    }];
    
    // dispatch your final block after all the dispatch_group_enters
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"finally!");
    });
    */
    
    /*
    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
    [rootViewController presentViewController:reg animated:YES completion:^{}];
    */
}
- (void)computeInBackground:(int)no completion:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"%d starting", no);
        sleep(no*2);
        block();
    });
}
- (void)getGoogleUserLogin{
    MCLogger(@"getGoogleUserLogin>>>>>>INTO>>>>>>>");
    MCGooglePlus* reg = [[MCGooglePlus alloc] init];
    [[[UIApplication sharedApplication] keyWindow]addSubview:reg.view];
    MCLogger(@"getGoogleUserLogin>>>>>>END>>>>>>>");
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MCLogger(@"viewWillAppear>>>>>%@>>>>>",isGoogleLogin?@"YES":@"NO");
    
    if (isGoogleLogin == YES) {
        
        NSString* googleUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"googleUserID"];
        NSString* googleUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"googleUserEMAIL"];
        MCLogger(@"viewWillAppear>>>>>>%@",googleUserEmail);
        MCLogger(@"viewWillAppear>>>>>>%@",googleUserID);
        
        MCLogin* mcl = [[MCLogin alloc] init];
        
        [mcl GetAmbitUserInfoViaOpenID:googleUserEmail
                               openUID:googleUserID
                            login_type:LOGIN_TYPE_GOOGLE sysID:@"OTT_ARDI"
                               success:^(id responseObject) {
                                   
                                   NSData* responseData = (NSData*)responseObject;
                                   MCLogger(@"%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                                   
                                   
                                   NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                                   
                                   if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-429"]) {
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>-429>>>>>>>>>>>>>>");
                                       
                                       NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:googleUserEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_GOOGLE,@"LOGIN_TYPE",googleUserID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                       
                                       RegisterViewController* reg = [[RegisterViewController alloc] init];
                                       [reg setResultJason:dict];
                                       
                                       UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                       [rootViewController presentViewController:reg animated:YES completion:^{}];
                                   }
                                   
                                   if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-430"]) {
                                       
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>-430>>>>>>>>>>>>>>");
                                       
                                       OpenIDBundlingViewController* reg = [[OpenIDBundlingViewController alloc] init];
                                       
                                       
                                       NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:googleUserEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_GOOGLE,@"LOGIN_TYPE",googleUserID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                       
                                       [reg setResultJason:dict];
                                       
                                       UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                       [rootViewController presentViewController:reg animated:YES completion:^{}];
                                       
                                       
                                   }
                               } failure:^(NSError *error) {
                                   
                               }];
    }else if (isTwitterLogin == YES) {
        
        NSString* twitterUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUserID"];
        NSString* twitterUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUserEMAIL"];
        MCLogger(@"viewWillAppear>>>>>>%@",twitterUserID);
        MCLogger(@"viewWillAppear>>>>>>%@",twitterUserEmail);
        
        MCLogin* mcl = [[MCLogin alloc] init];
        
        [mcl GetAmbitUserInfoViaOpenID:twitterUserEmail
                               openUID:twitterUserID
                            login_type:LOGIN_TYPE_TWITTER sysID:@"OTT_ARDI"
                               success:^(id responseObject) {
                                   
                                   NSData* responseData = (NSData*)responseObject;
                                   MCLogger(@"%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                                   
                                   
                                   NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                                   
                                   if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-429"]) {
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>-429>>>>>>>>>>>>>>");
                                       
                                       NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:twitterUserEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_TWITTER,@"LOGIN_TYPE",twitterUserID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                       
                                       RegisterViewController* reg = [[RegisterViewController alloc] init];
                                       [reg setResultJason:dict];
                                       
                                       UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                       [rootViewController presentViewController:reg animated:YES completion:^{}];
                                   }
                                   
                                   if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-430"]) {
                                       
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>-430>>>>>>>>>>>>>>");
                                       
                                       OpenIDBundlingViewController* reg = [[OpenIDBundlingViewController alloc] init];
                                       
                                       
                                       NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:twitterUserEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_TWITTER,@"LOGIN_TYPE",twitterUserID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                       
                                       [reg setResultJason:dict];
                                       
                                       UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                       [rootViewController presentViewController:reg animated:YES completion:^{}];
                                       
                                       
                                   }
                               } failure:^(NSError *error) {
                                   
                               }];
    }else if (isSinaWeiboLogin == YES) {
        
        NSString* sinaWeiboUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"sinaWeiboUserID"];
        NSString* sinaWeiboUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"sinaWeiboUserEMAIL"];
        MCLogger(@"viewWillAppear>>>>>>%@",sinaWeiboUserID);
        MCLogger(@"viewWillAppear>>>>>>%@",sinaWeiboUserEmail);
        
        MCLogin* mcl = [[MCLogin alloc] init];
        
        [mcl GetAmbitUserInfoViaOpenID:sinaWeiboUserEmail
                               openUID:sinaWeiboUserID
                            login_type:LOGIN_TYPE_SINAWEIBO sysID:@"OTT_ARDI"
                               success:^(id responseObject) {
                                   
                                   NSData* responseData = (NSData*)responseObject;
                                   MCLogger(@"%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                                   
                                   
                                   NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                                   
                                   if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-429"]) {
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>-429>>>>>>>>>>>>>>");
                                       
                                       NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:sinaWeiboUserEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_SINAWEIBO,@"LOGIN_TYPE",sinaWeiboUserID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                       
                                       RegisterViewController* reg = [[RegisterViewController alloc] init];
                                       [reg setResultJason:dict];
                                       
                                       UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                       [rootViewController presentViewController:reg animated:YES completion:^{}];
                                   }
                                   
                                   if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-430"]) {
                                       
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>-430>>>>>>>>>>>>>>");
                                       
                                       OpenIDBundlingViewController* reg = [[OpenIDBundlingViewController alloc] init];
                                       
                                       
                                       NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:sinaWeiboUserEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_SINAWEIBO,@"LOGIN_TYPE",sinaWeiboUserID,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                       
                                       [reg setResultJason:dict];
                                       
                                       UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                       MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                       [rootViewController presentViewController:reg animated:YES completion:^{}];
                                       
                                       
                                   }
                               } failure:^(NSError *error) {
                                   
                               }];
    }

}
- (IBAction)twitterLogin:(id)sender {
    
    isTwitterLogin = YES;
    MCTwitter* twitter = [[MCTwitter alloc] init];
    
    
    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
    [rootViewController presentViewController:twitter animated:YES completion:^{}];
    
    
}
- (IBAction)weiboLogin:(id)sender {
    
    isSinaWeiboLogin = YES;
    MCSinaWeibo* sinaWeibo = [[MCSinaWeibo alloc] init];
    
    
    UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    MCLogger(@"FBLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
    [rootViewController presentViewController:sinaWeibo animated:YES completion:^{}];
    
    
}
- (IBAction)yahooLogin:(id)sender {
    MCLogger(@"YahooLogin>>>>>>>>>>>>>INTO>>>>>>>>>>>>>>");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate createYahooSession];
    NSLog(@"yahoo create finish>>>>>");
}
- (void)loadYahooUserProfile:(NSMutableDictionary *)params
{
    NSLog(@"loadYahooUserProfile>>>>>");
    // Check e-mail
    NSString *yahooGuid = [params objectForKey:@"yahooGuid"];
    
    NSLog(@"Yahoo GUID: %@", yahooGuid);
    
    NSString *yahooEmail = [params objectForKey:@"yahooEmail"];
    
    MCLogger(@"viewWillAppear>>>yahooEmail>>>%@",yahooEmail);
    
    MCLogin* mcl = [[MCLogin alloc] init];
    
    [mcl GetAmbitUserInfoViaOpenID:yahooEmail
                           openUID:yahooGuid
                        login_type:LOGIN_TYPE_YAHOO sysID:@"OTT_ARDI"
                           success:^(id responseObject) {
                               
                               NSData* responseData = (NSData*)responseObject;
                               MCLogger(@"%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                               
                               
                               NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                               
                               if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-429"]) {
                                   MCLogger(@"YahooLogin>>>>>>>>>>>>>-429>>>>>>>>>>>>>>");
                                   
                                   NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:yahooEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_YAHOO,@"LOGIN_TYPE",yahooGuid,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                   
                                   RegisterViewController* reg = [[RegisterViewController alloc] init];
                                   [reg setResultJason:dict];
                                   [reg setLOGIN_TYPE:@"Yahoo"];
                                   
                                   UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                   MCLogger(@"YahooLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                   [rootViewController presentViewController:reg animated:YES completion:^{}];
                               }
                               
                               if ([[resultJSON objectForKey:@"returnCode"] isEqual:@"-430"]) {
                                   
                                   MCLogger(@"YahooLogin>>>>>>>>>>>>>-430>>>>>>>>>>>>>>");
                                   
                                   OpenIDBundlingViewController* reg = [[OpenIDBundlingViewController alloc] init];
                                   
                                   
                                   NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:yahooEmail, @"EMAIL", @"OTT_ARDI", @"SYS_ID",LOGIN_TYPE_YAHOO,@"LOGIN_TYPE",yahooGuid,@"LOGIN_UID",[resultJSON objectForKey:@"VALID_STR"],@"VALID_STR",[resultJSON objectForKey:@"CHECK_DATE"],@"CHECK_DATE", nil];
                                   
                                   [reg setResultJason:dict];
                                   [reg setLOGIN_TYPE:@"Yahoo"];
                                   
                                   UIViewController* rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
                                   MCLogger(@"YahooLogin>>>>>>>>>>>>>presentViewController>>>>>>>>>>>>>>");
                                   [rootViewController presentViewController:reg animated:YES completion:^{}];
                                   
                                   
                               }
                               
                               NSLog(@"Yahoo登入成功~~~~~~~");
                           } failure:^(NSError *error) {
                               
                           }];
    
}



@end
