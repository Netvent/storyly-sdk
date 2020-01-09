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

- (BOOL)storylyActionClicked:(StorylyView * _Nonnull)storylyView
          rootViewController:(UIViewController * _Nonnull)rootViewController
                       story:(Story * _Nonnull)story {

    NSMutableDictionary* storyDataMap = [NSMutableDictionary new];
    for (StorylyData *data in story.media.data) {
        [storyDataMap setObject:data.value forKey:data.key];
    }
    if (self.onStorylyActionClicked) {
        self.onStorylyActionClicked(@{
            @"index": @(story.index),
            @"title": story.title,
            @"media": @{
                    @"type": @(story.media.type),
                    @"url": story.media.url,
                    @"buttonText": story.media.buttonText,
                    @"actionUrl": story.media.actionUrl,
                    @"data": storyDataMap
            }});
    }
    return YES;
}

- (void)storylyLoadFailed:(StorylyView * _Nonnull)storylyView
                    error:(StorylyError * _Nonnull)error {
    if (self.onStorylyLoadFailed) {
        self.onStorylyLoadFailed(@{});
    }
}

- (void)storylyLoaded:(StorylyView * _Nonnull)storylyView {
    if (self.onStorylyLoaded) {
        self.onStorylyLoaded(@{});
    }
}

@end
