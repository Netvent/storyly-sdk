//
//  IntegrationViewController.m
//  StorylyDemo
//
//  Created by Haldun Melih Fadillioglu on 7.02.2022.
//  Copyright © 2022 App Samurai Inc. All rights reserved.
//

#import "IntegrationViewController.h"

@interface IntegrationViewController ()

@property (weak, nonatomic) IBOutlet StorylyView *storylyView;

@end

@implementation IntegrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId: @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjEwNDA5fQ.kXqBdpUcKaJe7eA98PqHahMDf-123Uhb82t_mYzbBUM"];
    self.storylyView.rootViewController = self;
    self.storylyView.delegate = self;
}

- (NSString *)segueFromActionUrl:(NSString *)url {
    if (url == nil) { return nil; }
    NSURL * actionUrl = [NSURL URLWithString: url];
    if (actionUrl == nil || ![actionUrl.scheme  isEqual: @"app"] || ![actionUrl.host isEqual: @"storyly-demo"]) { return nil; }
    NSString * segueId = actionUrl.path;
    return [self canPerformSegueWithIdentifier:segueId] ? segueId : nil;
}

- (BOOL)canPerformSegueWithIdentifier:(NSString *)identifier {
    NSArray *segueTemplates = [self valueForKey:@"storyboardSegueTemplates"];
    NSArray *filteredArray = [segueTemplates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", identifier]];
    return filteredArray.count>0;
}

- (void)storylyLoaded:(StorylyView *)storylyView
       storyGroupList:(NSArray<StoryGroup *> *)storyGroupList
           dataSource:(enum StorylyDataSource)dataSource {
    NSLog(@"[storyly] IntegrationViewController:storylyLoaded - storyGroupList size {%lu)} - source {%ld)}", (unsigned long)storyGroupList.count, (long)dataSource);
}

- (void)storylyLoadFailed:(StorylyView *)storylyView
             errorMessage:(NSString *)errorMessage {
    NSLog(@"[storyly] IntegrationViewController:storylyLoadFailed - error {%@)}", errorMessage);
}

- (void)storylyActionClicked:(StorylyView *)storylyView
          rootViewController:(UIViewController *)rootViewController
                       story:(Story *)story {
    NSLog(@"[storyly] IntegrationViewController:storylyActionClicked - story action_url {%@)}", story.media.actionUrl);
    NSString *segueId = [self segueFromActionUrl:story.media.actionUrl];
    if (segueId == nil) {
        NSLog(@"[storyly]: IntegrationViewController - action_url not valid");
        return;
    }
    [storylyView dismissWithAnimated:true completion: nil];
    [self performSegueWithIdentifier:segueId sender:self];
}

@end
