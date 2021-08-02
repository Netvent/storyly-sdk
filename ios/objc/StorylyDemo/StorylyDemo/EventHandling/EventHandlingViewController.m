//
//  EventHandlingViewController.m
//  StorylyDemo
//
//  Created by Levent Oral on 8.02.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

#import "EventHandlingViewController.h"
#import "Tokens.h"

@interface EventHandlingViewController ()
@property (weak, nonatomic) IBOutlet StorylyView *storylyView;
@end

@implementation EventHandlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId: STORYLY_INSTANCE_TOKEN];
    self.storylyView.rootViewController = self;
    self.storylyView.delegate = self;
}

- (void)storylyLoaded:(StorylyView *)storylyView
       storyGroupList:(NSArray<StoryGroup *> *)storyGroupList {
}

- (void)storylyLoadFailed:(StorylyView *)storylyView
             errorMessage:(NSString *)errorMessage {
}

- (void)storylyActionClicked:(StorylyView *)storylyView
          rootViewController:(UIViewController *)rootViewController
                       story:(Story *)story {
}

- (void)storylyStoryPresented:(StorylyView *)storylyView{
}

- (void)storylyStoryDismissed:(StorylyView *)storylyView {
}

- (void)storylyUserInteracted:(StorylyView *)storylyView
                   storyGroup:(StoryGroup *)storyGroup
                        story:(Story *)story
               storyComponent:(StoryComponent *)storyComponent {
}

- (void)storylyEvent:(StorylyView *)storylyView
               event:(enum StorylyEvent)event
          storyGroup:(StoryGroup *)storyGroup
               story:(Story *)story
      storyComponent:(StoryComponent *)storyComponent {
}

@end
