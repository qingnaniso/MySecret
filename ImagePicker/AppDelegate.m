//
//  SecretPhotosLibViewController.m
//  SecretPhotosLib
//
//  Created by Qiqingnan on 14-6-17.
//  Copyright (c) 2014年 qiqingnan. All rights reserved.
//

#import "AppDelegate.h"
#import "SecretPhotosLibViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.5];
    [_window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    self.screenShotView = [[UIImageView alloc]initWithFrame:[self.window frame]];
    [self.screenShotView setImage:[UIImage imageNamed:@"Start Here 3.png"]];
    [self.window addSubview:self.screenShotView];
    self.screenShotView.alpha = 0;
    [self.window bringSubviewToFront:self.screenShotView];
    [UIView animateWithDuration:0.5 animations:^{
        self.screenShotView.alpha = 1;
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecretPhotosLibViewController *loginVC = (SecretPhotosLibViewController *)[storyboard instantiateInitialViewController];
    [self.window setRootViewController:loginVC];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.screenShotView.alpha = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
