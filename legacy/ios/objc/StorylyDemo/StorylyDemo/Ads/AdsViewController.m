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
@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.storylyView.rootViewController = self;
}

@end
