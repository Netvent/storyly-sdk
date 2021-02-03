//
//  UIViewController+CustomThemeViewController.m
//  StorylyDemo
//
//  Created by Haldun Melih Fadillioglu on 3.02.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

#import "CustomThemeViewController.h"

@interface CustomThemeViewContoller ()

@property (weak, nonatomic) IBOutlet StorylyView *storylyViewDefaultTheme;
@property (weak, nonatomic) IBOutlet StorylyView *storylyViewCustomTheme;

@end

@implementation CustomThemeViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjQ3LCJhcHBfaWQiOjEyODcsImluc19pZCI6MTYzMX0.mjY5nZ5mPk0H6v5xiexJnpNzGGsn335Cm2mYlzCWo4A";
    
    self.storylyViewDefaultTheme.storylyInit = [[StorylyInit alloc] initWithStorylyId: YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
    self.storylyViewDefaultTheme.rootViewController = self;

    
    self.storylyViewCustomTheme.storylyInit = [[StorylyInit alloc] initWithStorylyId: YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
    self.storylyViewCustomTheme.rootViewController = self;
    
//    self.storylyViewCustomTheme.storyGroupTextColor = [UIColor colorWithRed: 240.0/255.0 green: 57.0/255.0 blue: 50.0/255.0 alpha: 1.0];
//    self.storylyViewCustomTheme.storyGroupIconBackgroundColor = [UIColor colorWithRed: 76.0/25.0 green: 175.0/255.0 blue: 80.0/255.0 alpha: 1.0];
    
    self.storylyViewCustomTheme.storyGroupIconBorderColorSeen = [[NSArray alloc] initWithObjects:
                                                                 [UIColor colorWithRed: 197.0/255.0 green: 172.0/255.0 blue: 165.0/255.0 alpha: 1.0],
                                                                 [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0], nil];
    
    self.storylyViewCustomTheme.storyGroupIconBorderColorNotSeen = [[NSArray alloc] initWithObjects:
                                                                    [UIColor colorWithRed: 251.0/255.0 green: 50.0/255.0 blue: 0 alpha: 1.0],
                                                                    [UIColor colorWithRed: 1.0 green: 235.0/255.0 blue: 59.0/255.0 alpha: 1.0], nil];
    
//    self.storylyViewCustomTheme.storyGroupPinIconColor = [UIColor colorWithRed: 63.0/255.0 green: 81.0/255.0 blue: 181.0/255.0 alpha: 1.0];

//    self.storylyViewCustomTheme.storyItemTextColor = [UIColor colorWithRed: 255.0/255.0 green: 0 blue: 87.0/255.0 alpha: 1.0];

    self.storylyViewCustomTheme.storyItemIconBorderColor = [[NSArray alloc] initWithObjects:
                                                           [UIColor colorWithRed: 251.0/255.0 green: 50.0/255.0 blue: 0 alpha: 1.0],
                                                           [UIColor colorWithRed: 255.0/255.0 green: 235.0/255.0 blue: 59.0/255.0 alpha: 1.0], nil];
    
    self.storylyViewCustomTheme.storylyItemProgressBarColor =  [[NSArray alloc] initWithObjects:
                                                                [UIColor colorWithRed: 251.0/255.0 green: 50.0/255.0 blue: 0 alpha: 1.0],
                                                                [UIColor colorWithRed: 255.0/255.0 green: 235.0/255.0 blue: 59.0/255.0 alpha: 1.0], nil];

}

@end
