//
//  ViewController.m
//  StorylyDemo
//
//  Created by Levent ORAL on 18.02.2020.
//  Copyright © 2020 App Samurai Inc. All rights reserved.
//

#import "BasicViewController.h"
#import "Tokens.h"

@interface BasicViewController ()
@property (weak, nonatomic) IBOutlet StorylyView *storylyView;
@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId: STORYLY_INSTANCE_TOKEN];
    self.storylyView.rootViewController = self;
    
    StorylyView *storylyViewProgrammatic = [[StorylyView alloc] init];
    storylyViewProgrammatic.translatesAutoresizingMaskIntoConstraints = NO;
    storylyViewProgrammatic.storylyInit = [[StorylyInit alloc] initWithStorylyId: STORYLY_INSTANCE_TOKEN];
    storylyViewProgrammatic.rootViewController = self;
    [self.view addSubview:storylyViewProgrammatic];
    [[storylyViewProgrammatic.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[storylyViewProgrammatic.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[storylyViewProgrammatic.topAnchor constraintEqualToAnchor:self.storylyView.bottomAnchor constant:10] setActive:YES];
    [[storylyViewProgrammatic.heightAnchor constraintEqualToConstant:120] setActive:YES];
}

@end
