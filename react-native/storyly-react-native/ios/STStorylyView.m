//
//  STStorlyView.m
//
//  Created by Levent ORAL on 31.12.2019.
//

#import "STStorylyView.h"

@implementation STStorylyView {
    StorylyView *_storylyView;
}

-(void)dealloc {
    _storylyView.delegate = nil;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootViewController = [keyWindow rootViewController];
        _storylyView = [[StorylyView alloc] initWithFrame:frame];
        _storylyView.delegate = self;
        _storylyView.rootViewController = rootViewController;
        [self addSubview:_storylyView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_storylyView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_storylyView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_storylyView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor].active = YES;
    [_storylyView.heightAnchor constraintEqualToConstant:self.frame.size.height].active = YES;
}

- (void) refresh {
    [_storylyView refresh];
}

- (void) open {
    [_storylyView presentWithAnimated:false completion:nil];
    [_storylyView resume];
}

- (void) close {
    [_storylyView pause];
    [_storylyView dismissWithAnimated:false completion:nil];
}

- (BOOL) openStory:(NSURL *)payload {
    return [_storylyView openStoryWithPayload:payload];
}

- (BOOL) setExternalData:(NSArray<NSDictionary *> *)externalData {
    return [_storylyView setExternalDataWithExternalData:externalData];
}

- (BOOL)storylyActionClicked:(StorylyView * _Nonnull)storylyView
          rootViewController:(UIViewController * _Nonnull)rootViewController
                       story:(Story * _Nonnull)story {
    if (self.onStorylyActionClicked) {
        self.onStorylyActionClicked([self createStoryMap:story]);
    }
    return YES;
}

- (void)storylyLoaded:(StorylyView * _Nonnull)storylyView
       storyGroupList:(NSArray<StoryGroup *> *)storyGroupList {
    if (self.onStorylyLoaded) {
        NSMutableArray* storyGroups = [NSMutableArray new];
        for (StoryGroup *storyGroup in storyGroupList) {
            [storyGroups addObject:[self createStoryGroupMap:storyGroup]];
        }
        self.onStorylyLoaded([NSDictionary dictionaryWithObjects:storyGroups
                                                         forKeys:[storyGroups valueForKey:@"intField"]]);
    }
    
}

-(void)storylyLoadFailed:(StorylyView *)storylyView errorMessage:(NSString *)errorMessage {
    if (self.onStorylyLoadFailed) {
        self.onStorylyLoadFailed(@{@"errorMessage": errorMessage});
    }
}

- (void)storylyStoryPresented:(StorylyView * _Nonnull)storylyView {
    if (self.onStorylyStoryPresented) {
        self.onStorylyStoryPresented(@{});
    }
}

- (void)storylyStoryDismissed:(StorylyView * _Nonnull)storylyView {
    if (self.onStorylyStoryDismissed) {
        self.onStorylyStoryDismissed(@{});
    }
}

-(NSDictionary *)createStoryGroupMap:(StoryGroup * _Nonnull)storyGroup {
    NSMutableArray* stories = [NSMutableArray new];
    for (Story *story in storyGroup.stories) {
        [stories addObject:[self createStoryMap:story]];
    }
    return @{
        @"index": @(storyGroup.index),
        @"title": storyGroup.title,
        @"stories": stories
    };
}

-(NSDictionary *)createStoryMap:(Story * _Nonnull)story {
    return @{
        @"index": @(story.index),
        @"title": story.title,
        @"media": @{
                @"type": @(story.media.type),
                @"url": story.media.url,
                @"actionUrl": story.media.actionUrl
        }};
}

@end
