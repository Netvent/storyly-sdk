//
//  AppDelegate.m
//  StorylyDemo
//
//  Created by Levent ORAL on 18.02.2020.
//  Copyright © 2020 App Samurai Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    return YES;
}

@end
