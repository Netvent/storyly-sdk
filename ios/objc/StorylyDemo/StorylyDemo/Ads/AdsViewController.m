//
//  AdsViewController.m
//  StorylyDemo
//
//  Created by Levent Oral on 27.07.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

#import "AdsViewController.h"
#import "Tokens.h"

@interface AdsViewController ()
@property (weak, nonatomic) IBOutlet StorylyView *storylyView;
@property (strong, nonatomic) StorylyAdViewProvider *storylyAdViewProvider;
@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storylyAdViewProvider = [[StorylyAdViewProvider alloc] initWithRootViewController:self adMobAdUnitId:ADMOB_NATIVE_AD_ID];
    
    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId: STORYLY_INSTANCE_TOKEN];
    self.storylyView.rootViewController = self;
    self.storylyView.storylyAdViewProvider = self.storylyAdViewProvider;
}

@end
