//
//  AppDelegate.m
//  HelpCenter
//
//  Created by Developers on 12. 10. 10..
//  Copyright (c) 2012년 kthcorp. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
