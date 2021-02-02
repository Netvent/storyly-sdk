//
//  UIViewController+CustomSizeViewController.m
//  StorylyDemo
//
//  Created by Haldun Melih Fadillioglu on 2.02.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

#import "CustomSizeViewController.h"

@interface CustomSizeViewController ()

@property (weak, nonatomic) IBOutlet StorylyView *storylyViewSmall;
@property (weak, nonatomic) IBOutlet StorylyView *storylyViewLarge;
@property (weak, nonatomic) IBOutlet StorylyView *storylyViewXLarge;
@property (weak, nonatomic) IBOutlet StorylyView *storylyViewPortrait;
@property (weak, nonatomic) IBOutlet StorylyView *storylyViewLandscape;

@end

@implementation CustomSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.storylyViewSmall.storylyInit = [[StorylyInit alloc] initWithStorylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
    self.storylyViewSmall.rootViewController = self;
    self.storylyViewSmall.storyGroupSize = @"small";
    
    self.storylyViewLarge.storylyInit = [[StorylyInit alloc] initWithStorylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
    self.storylyViewLarge.rootViewController = self;
    self.storylyViewLarge.storyGroupSize = @"large";
    
    self.storylyViewXLarge.storylyInit = [[StorylyInit alloc] initWithStorylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
    self.storylyViewXLarge.rootViewController = self;
    self.storylyViewXLarge.storyGroupSize = @"xlarge";
    
    self.storylyViewPortrait.storylyInit = [[StorylyInit alloc] initWithStorylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
    self.storylyViewPortrait.rootViewController = self;
    self.storylyViewPortrait.storyGroupSize = @"custom";
    
//    self.storylyViewPortrait.storyGroupIconStyling = [[StoryGroupIconStyling alloc] initWithHeight:150 width:100 cornerRadius:15];
    
//    self.storylyViewPortrait.storyGroupIconHeight = 150;
//    self.storylyViewPortrait.storyGroupIconWidth = 100;
//    self.storylyViewPortrait.storyGroupIconCornerRadius = 15;
    
    self.storylyViewLandscape.storylyInit = [[StorylyInit alloc] initWithStorylyId: @YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
    self.storylyViewLandscape.rootViewController = self;
    self.storylyViewLandscape.storyGroupSize = @"custom";
    
//    self.storylyViewLandscape.storyGroupIconStyling = [[StoryGroupIconStyling alloc] initWithHeight:100 width:150 cornerRadius:15];
    
//    self.storylyViewLandscape.storyGroupIconHeight = 100;
//    self.storylyViewLandscape.storyGroupIconWidth = 150;
//    self.storylyViewLandscape.storyGroupIconCornerRadius = 15;
}

@end
