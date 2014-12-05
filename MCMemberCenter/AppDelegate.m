//
//  AppDelegate.m
//  MCMemberCenter
//
//  Created by Ken on 2014/10/6.
//  Copyright (c) 2014年 Ken. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"
#import <MC/MCYahoo.h>
#import "ViewController.h"

@interface AppDelegate () <YahooSessionDelegate>

@property (strong, nonatomic) YahooSession *session;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

@implementation AppDelegate

- (void)didReceiveAuthorization
{
    [self createYahooSession];
}

- (void)createYahooSession
{
    // Create session with consumer key, secret and application id
    // Set up a new app here: https://developer.yahoo.com/dashboard/createKey.html
    // The default values here won't work
    
    self.session = [YahooSession sessionWithConsumerKey:@"dj0yJmk9M1BqTkhnNU9TRUVaJmQ9WVdrOU0xSnlVakpuTlRJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1hNQ--"
                                      andConsumerSecret:@"67befb530eb925e8a66fa589fe540ce605ebdf9b"
                                       andApplicationId:@"3RrR2g52"
                                         andCallbackUrl:@"http://ambit.ddns.net/index.jsp"
                                            andDelegate:self];
    // Try to resume a user session if one exists
    BOOL hasSession = [self.session resumeSession];
    NSLog(@"%i",hasSession);
    
    if(!hasSession) {
        // Not logged-in, send login and authorization pages to user
        [self.session sendUserToAuthorization];
    } else {
        // Logged-in, send requests
        NSLog(@"Session detected!");
        [self sendUserProfileRequest];
        //[self pushUserProfileToVC];
    }
}

- (void)sendUserProfileRequest
{
    // Initialize profile request
    YOSUserRequest *userRequest = [YOSUserRequest requestWithSession:self.session];
    
    // Fetch user profile
    [userRequest fetchProfileWithDelegate:self];
}

// Waiting to fetch response
- (void)requestDidFinishLoading:(YOSResponseData *)data
{
    // Get the JSON response, will exist ONLY if requested response is JSON
    // If JSON does not exist, use data.responseText for NSString response
    NSLog(@"requestDidFinishLoading!");
    MCYahoo *mYahoo = [[MCYahoo alloc] init];
    if (data.responseJSONDict[@"profile"]) {
        mYahoo.userProfile = data.responseJSONDict;
        [mYahoo getUserInfoWithSuccess:^(id responseObject) {
            NSMutableDictionary *params = (NSMutableDictionary*)responseObject;
            ViewController* reg = [[ViewController alloc] init];
            [reg loadYahooUserProfile:params];
            [self.window.rootViewController presentViewController:reg animated:YES completion:^{}];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FBLoginView class];
    [FBProfilePictureView class];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"sourceApplication<<<<<<%@<<<<<<<<<",sourceApplication);
    NSLog(@"url<<<<<<%@<<<<<<<<<",[url absoluteString]);
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
//    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    if ([[url absoluteString] rangeOfString:@"com.acer.ke9ktestez"].location ==            NSNotFound)
    {
        // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
        BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
        // You can add your app-specific url handling code here if needed
        return wasHandled;
    }
    else
    {
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }
    return YES;
    
    
//    return wasHandled;
}
/*
- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation
{
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}*/
@end
