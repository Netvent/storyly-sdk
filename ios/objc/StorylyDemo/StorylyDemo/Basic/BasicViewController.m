//
//  ViewController.m
//  StorylyDemo
//
//  Created by Levent ORAL on 18.02.2020.
//  Copyright © 2020 App Samurai Inc. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()
@property (weak, nonatomic) IBOutlet StorylyView *storylyView;
@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId: @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"];
    self.storylyView.rootViewController = self;
    
    StorylyView *storylyViewProgrammatic = [[StorylyView alloc] init];
    storylyViewProgrammatic.translatesAutoresizingMaskIntoConstraints = NO;
    storylyViewProgrammatic.storylyInit = [[StorylyInit alloc] initWithStorylyId: @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"];
    storylyViewProgrammatic.rootViewController = self;
    [self.view addSubview:storylyViewProgrammatic];
    [[storylyViewProgrammatic.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[storylyViewProgrammatic.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[storylyViewProgrammatic.topAnchor constraintEqualToAnchor:self.storylyView.bottomAnchor constant:10] setActive:YES];
    [[storylyViewProgrammatic.heightAnchor constraintEqualToConstant:120] setActive:YES];
}

@end
