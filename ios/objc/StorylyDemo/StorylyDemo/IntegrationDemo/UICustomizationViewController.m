//
//  UICustomizationViewController.m
//  StorylyDemo
//
//  Created by Haldun Melih Fadillioglu on 7.02.2022.
//  Copyright © 2022 App Samurai Inc. All rights reserved.
//

#import "UICustomizationViewController.h"

@interface UICustomizationViewController ()

@property (weak, nonatomic) IBOutlet StorylyView *storylyView;

@end

@implementation UICustomizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId:  @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjEwNDA5fQ.kXqBdpUcKaJe7eA98PqHahMDf-123Uhb82t_mYzbBUM"
//        ];
    self.storylyView.rootViewController = self;
    self.storylyView.delegate = self;
}



@end
