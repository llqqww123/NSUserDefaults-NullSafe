//
//  AppDelegate.m
//  NSUserDefaultsNullSafeExample
//
//  Created by 雷琦玮 on 2019/8/16.
//  Copyright © 2019 雷琦玮. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
//    NSDictionary *json = @{
//                           @"1":[NSNull null],
//                           @"2":@"2",
//                           @"3":[NSNull null],
//                           @"4":@"4",
//                           @"5":@[
//                                   @(5),
//                                   [NSNull null],
//                                   @(7),
//                                   [NSNull null],
//                                   @{
//                                       @"9":@{
//                                               @"10":@"10",
//                                               @"11":@"11",
//                                               @"12":[NSNull null]
//                                               }
//                                       }
//                                   ]
//                           };
    
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"123"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
