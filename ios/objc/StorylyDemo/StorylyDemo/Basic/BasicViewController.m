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
    self.storylyView.delegate = self;
    self.storylyView.rootViewController = self;
    StorylyView *storylyViewProgrammatic = [[StorylyView alloc] init];
    storylyViewProgrammatic.rootViewController = self;
    storylyViewProgrammatic.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:storylyViewProgrammatic];
    
    [[storylyViewProgrammatic.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[storylyViewProgrammatic.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[storylyViewProgrammatic.topAnchor constraintEqualToAnchor:self.storylyView.bottomAnchor constant:50] setActive:YES];
    [[storylyViewProgrammatic.heightAnchor constraintEqualToConstant:120] setActive:YES];
    

    StorylyStoryGroupStyling *groupStyling = [[[[[[[StorylyStoryGroupStylingBuilder alloc] init]
                                              setSize:StoryGroupSizeCustom]
                                              setIconHeight:120]
                                              setIconWidth:120]
                                              setIconCornerRadius:12]
                                              build];
       
    StorylyBarStyling *barStyling = [[[[StorylyBarStylingBuilder alloc] init]
                                     setHorizontalPaddingBetweenItems:15]
                                     build];
    
    StorylyStoryStyling *storyStyling = [[[[StorylyStoryStylingBuilder alloc] init]
                                         setTitleColor: UIColor.redColor]
                                         build];
             
    StorylyConfig *storylyConfig = [[[[[[StorylyConfigBuilder alloc] init]
                                     setStoryGroupStyling:groupStyling]
                                     setBarStyling:barStyling]
                                     setStoryStyling:storyStyling]
                                     build];
         
       
    storylyViewProgrammatic.storylyInit = [[StorylyInit alloc] initWithStorylyId:STORYLY_INSTANCE_TOKEN config:storylyConfig];
    self.storylyView.storylyInit = [[StorylyInit alloc] initWithStorylyId:STORYLY_INSTANCE_TOKEN config:storylyConfig];
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
    [storylyView closeStoryWithAnimated:true completion:nil];
}

@end
