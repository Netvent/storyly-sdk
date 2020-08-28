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
    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId:@YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD];
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

- (void)storylyUserInteracted:(StorylyView *)storylyView storyGroup:(StoryGroup *)storyGroup story:(Story *)story storyComponent:(StoryComponent *)storyComponent {
    switch (storyComponent.type) {
        case StoryComponentTypeQuiz:
            {
                StoryQuizComponent *quizComponent = (StoryQuizComponent *)storyComponent;
                // quizComponent actions
            }
            break;
        case StoryComponentTypePoll:
            {
                StoryPollComponent *pollComponent = (StoryPollComponent *)storyComponent;
                // pollComponent actions
            }
            break;
        case StoryComponentTypeEmoji:
            {
                StoryEmojiComponent *emojiComponent = (StoryEmojiComponent *)storyComponent;
                // emojiComponent actions
            }
            break;
        case StoryComponentTypeUndefined:
            break;
        default:
            break;
    }
}

@end
