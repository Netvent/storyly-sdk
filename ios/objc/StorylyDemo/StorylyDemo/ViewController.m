//
//  ViewController.m
//  StorylyDemo
//
//  Created by Levent ORAL on 18.02.2020.
//  Copyright © 2020 App Samurai Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet StorylyView *storylyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storylyView.storylyId = [YOUR_APP_ID_FROM_DASHBOARD]
    self.storylyView.rootViewController = self;
    self.storylyView.delegate = self;
}

-(void)storylyLoaded:(StorylyView *)storylyView storyGroupList:(NSArray<StoryGroup *> *)storyGroupList {
    NSLog(@"storylyLoaded");
}

- (void)storylyLoadFailed:(StorylyView *)storylyView errorMessage:(NSString *)errorMessage {
    NSLog(@"storylyLoadFailed");
}

- (BOOL)storylyActionClicked:(StorylyView *)storylyView rootViewController:(UIViewController *)rootViewController story:(Story *)story {
    NSLog(@"storylyActionClicked");
    return YES;
}

- (void)storylyStoryPresented:(StorylyView *)storylyView {
    NSLog(@"storylyStoryPresented");
}

- (void)storylyStoryDismissed:(StorylyView *)storylyView {
    NSLog(@"storylyStoryDismissed");
}

@end
