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
        [_storylyView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _storylyView.delegate = self;
        _storylyView.rootViewController = rootViewController;
        [self addSubview:_storylyView];
        [_storylyView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_storylyView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [_storylyView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_storylyView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    }
    return self;
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

- (BOOL) openStoryWithId:(NSNumber * _Nonnull)storyGroupId
           storyId:(NSNumber * _Nonnull)storyId {
    return [_storylyView openStoryWithId:storyGroupId storyId:storyId];
}

- (BOOL) setExternalData:(NSArray<NSDictionary *> *)externalData {
    return [_storylyView setExternalData:externalData];
}

- (void)storylyActionClicked:(StorylyView * _Nonnull)storylyView
          rootViewController:(UIViewController * _Nonnull)rootViewController
                       story:(Story * _Nonnull)story {
    if (self.onStorylyActionClicked) {
        self.onStorylyActionClicked([self createStoryMap:story]);
    }
}

- (void)storylyLoaded:(StorylyView * _Nonnull)storylyView
       storyGroupList:(NSArray<StoryGroup *> *)storyGroupList
           dataSource:(enum StorylyDataSource)dataSource {
    if (self.onStorylyLoaded) {
        NSMutableArray* storyGroups = [NSMutableArray new];
        for (StoryGroup *storyGroup in storyGroupList) {
            [storyGroups addObject:[self createStoryGroupMap:storyGroup]];
        }
        self.onStorylyLoaded(@{@"storyGroupList": storyGroups,
                               @"dataSource": [self convertStorylyDataSource:dataSource]});
    }
    
}

-(void)storylyLoadFailed:(StorylyView *)storylyView errorMessage:(NSString *)errorMessage {
    if (self.onStorylyLoadFailed) {
        self.onStorylyLoadFailed(@{@"errorMessage": errorMessage});
    }
}

- (void)storylyEvent:(StorylyView *)storylyView
               event:(enum StorylyEvent)event
          storyGroup:(StoryGroup *)storyGroup
               story:(Story *)story
      storyComponent:(StoryComponent *)storyComponent {
    if (self.onStorylyEvent) {
        self.onStorylyEvent(@{@"event": [StorylyEventHelper storylyEventNameWithEvent:event],
                              @"storyGroup": [self createStoryGroupMap:storyGroup],
                              @"story": [self createStoryMap:story],
                              @"storyComponent": [self createStoryComponentMap:storyComponent]});
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

- (void)storylyUserInteracted:(StorylyView * _Nonnull)storylyView
               storyGroup:(StoryGroup  *)storyGroup
                    story:(Story *)story
           storyComponent:(StoryComponent *)storyComponent {
    if (self.onStorylyUserInteracted) {
        self.onStorylyUserInteracted(@{@"storyGroup": [self createStoryGroupMap:storyGroup],
                                       @"story": [self createStoryMap:story],
                                       @"storyComponent": [self createStoryComponentMap:storyComponent]});
    }
}

-(NSDictionary *)createStoryGroupMap:(StoryGroup * _Nonnull)storyGroup {
    NSMutableArray* stories = [NSMutableArray new];
    for (Story *story in storyGroup.stories) {
        [stories addObject:[self createStoryMap:story]];
    }
    return @{
        @"id": @(storyGroup.id),
        @"index": @(storyGroup.index),
        @"title": storyGroup.title,
        @"seen": @(storyGroup.seen),
        @"iconUrl": storyGroup.iconUrl.absoluteString,
        @"stories": stories
    };
}

-(NSDictionary *)createStoryMap:(Story * _Nonnull)story {
    return @{
        @"id": @(story.id),
        @"index": @(story.index),
        @"title": story.title,
        @"seen": @(story.seen),
        @"media": @{
                @"type": @(story.media.type),
                @"actionUrl": story.media.actionUrl == nil ? [NSNull null] : story.media.actionUrl
        }};
}

-(NSDictionary *)createStoryComponentMap:(StoryComponent * _Nonnull)storyComponent {
    switch (storyComponent.type) {
        case StoryComponentTypeQuiz:
            {
                StoryQuizComponent *quizComponent = (StoryQuizComponent *)storyComponent;
                return @{
                    @"type": @"quiz",
                    @"title": quizComponent.title,
                    @"options": quizComponent.options,
                    @"rightAnswerIndex": quizComponent.rightAnswerIndex == nil ? [NSNull null] : quizComponent.rightAnswerIndex,
                    @"selectedOptionIndex": [NSNumber numberWithLong:quizComponent.selectedOptionIndex],
                    @"customPayload": quizComponent.customPayload == nil ? [NSNull null] : quizComponent.customPayload
                };
            }
            break;
        case StoryComponentTypePoll:
            {
                StoryPollComponent *pollComponent = (StoryPollComponent *)storyComponent;
                return @{
                    @"type": @"poll",
                    @"title": pollComponent.title,
                    @"options": pollComponent.options,
                    @"selectedOptionIndex": [NSNumber numberWithLong:pollComponent.selectedOptionIndex],
                    @"customPayload": pollComponent.customPayload == nil ? [NSNull null] : pollComponent.customPayload
                };
            }
            break;
        case StoryComponentTypeEmoji:
            {
                StoryEmojiComponent *emojiComponent = (StoryEmojiComponent *)storyComponent;
                return @{
                    @"type": @"emoji",
                    @"emojiCodes": emojiComponent.emojiCodes,
                    @"selectedEmojiIndex": [NSNumber numberWithLong:emojiComponent.selectedEmojiIndex],
                    @"customPayload": emojiComponent.customPayload == nil ? [NSNull null] : emojiComponent.customPayload
                };
            }
            break;
        case StoryComponentTypeRating:
            {
                StoryRatingComponent *ratingComponent = (StoryRatingComponent *)storyComponent;
                return @{
                    @"type": @"rating",
                    @"emojiCode": ratingComponent.emojiCode,
                    @"rating": [NSNumber numberWithLong:ratingComponent.rating],
                    @"customPayload": ratingComponent.customPayload == nil ? [NSNull null] : ratingComponent.customPayload
                };
            }
            break;
        case StoryComponentTypeUndefined:
            {
                return @{};
            }
            break;
        default:
            {
                return @{};
            }
            break;
    }
}


-(NSString *) convertStorylyDataSource:(enum StorylyDataSource)dataSource {
    if (dataSource == StorylyDataSourceAPI) { return @"api"; }
    else if (dataSource == StorylyDataSourceCDN) { return @"cdn"; }
    else if (dataSource == StorylyDataSourceLocal) { return @"local"; }
    else return @"";
}

@end
