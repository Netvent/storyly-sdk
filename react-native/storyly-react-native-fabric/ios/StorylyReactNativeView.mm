//
//  File.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 20.09.2023.
//

#import "StorylyReactNativeView.h"

#import <react/renderer/components/StorylyReactNativeSpec/ComponentDescriptors.h>
#import <react/renderer/components/StorylyReactNativeSpec/EventEmitters.h>
#import <react/renderer/components/StorylyReactNativeSpec/Props.h>
#import <react/renderer/components/StorylyReactNativeSpec/RCTComponentViewHelpers.h>

#import <storyly_react_native/storyly_react_native-Swift.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface StorylyReactNativeView () <RCTStorylyReactNativeViewViewProtocol>
@end

@implementation StorylyReactNativeView {
    STStorylyView *_stStorylyView;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<StorylyReactNativeViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
      static const auto defaultProps = std::make_shared<const StorylyReactNativeViewProps>();
      _props = defaultProps;

      _stStorylyView = [[STStorylyView alloc] initWithFrame: frame];

      __weak StorylyReactNativeView* weakSelf = self;
      _stStorylyView.onStorylyLoaded =  ^(NSString* raw) {
          __strong StorylyReactNativeView* strongSelf = weakSelf;
          std::dynamic_pointer_cast<const facebook::react::StorylyReactNativeViewEventEmitter>(strongSelf->_eventEmitter)
            ->onStorylyLoaded(facebook::react::StorylyReactNativeViewEventEmitter::OnStorylyLoaded{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyLoadFailed =  ^(NSString* raw) {
          __strong StorylyReactNativeView* strongSelf = weakSelf;
          std::dynamic_pointer_cast<const facebook::react::StorylyReactNativeViewEventEmitter>(strongSelf->_eventEmitter)
            ->onStorylyLoadFailed(facebook::react::StorylyReactNativeViewEventEmitter::OnStorylyLoadFailed{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyEvent =  ^(NSString* raw) {
          __strong StorylyReactNativeView* strongSelf = weakSelf;
          std::dynamic_pointer_cast<const facebook::react::StorylyReactNativeViewEventEmitter>(strongSelf->_eventEmitter)
            ->onStorylyEvent(facebook::react::StorylyReactNativeViewEventEmitter::OnStorylyEvent{std::string([raw UTF8String])});
      };
      
      self.contentView = _stStorylyView;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<StorylyReactNativeViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<StorylyReactNativeViewProps const>(props);

    if (oldViewProps.storylyConfig != newViewProps.storylyConfig) {
        _stStorylyView.storyBundleRaw = [NSString stringWithUTF8String: newViewProps.storylyConfig.c_str()];
    }

    [super updateProps:props oldProps:oldProps];
}

- (void)handleCommand:(nonnull const NSString *)commandName args:(nonnull const NSArray *)args {
    NSString* raw = args[0];
    if ([commandName isEqual:@"resumeStory"]) {
        [self resumeStory];
    } else if ([commandName isEqual:@"pauseStory"]) {
        [self pauseStory];
    } else if ([commandName isEqual:@"closeStory"]) {
        [self closeStory];
    } else if ([commandName isEqual:@"openStory"]) {
        [self openStory: raw];
    } else if ([commandName isEqual:@"openStoryWithId"]) {
        [self openStoryWithId: raw];
    } else if ([commandName isEqual:@"hydrateProducts"]) {
        [self hydrateProducts: raw];
    } else if ([commandName isEqual:@"updateCart"]) {
        [self updateCart: raw];
    } else if ([commandName isEqual:@"approveCartChange"]) {
        [self approveCartChange: raw];
    } else if ([commandName isEqual:@"rejectCartChange"]) {
        [self rejectCartChange: raw];
    } else {
        
    }
}

- (void)resumeStory {
    [_stStorylyView resumeStory];
}

- (void)pauseStory {
    [_stStorylyView pauseStory];
}

- (void)closeStory {
    [_stStorylyView closeStory];
}

- (void)openStory:(nonnull NSString *)raw {
    [_stStorylyView openStory: raw];
}

- (void)openStoryWithId:(nonnull NSString *)raw {
    [_stStorylyView openStoryId: raw];
}

- (void)hydrateProducts:(nonnull NSString *)raw {
    [_stStorylyView hydrateProducts: raw];
}

- (void)updateCart:(nonnull NSString *)raw {
    [_stStorylyView updateCart: raw];
}

- (void)approveCartChange:(nonnull NSString *)raw {
    [_stStorylyView approveCartChange: raw];
}

- (void)rejectCartChange:(nonnull NSString *)raw {
    [_stStorylyView rejectCartChange: raw];
}

@end

Class<RCTComponentViewProtocol> StorylyReactNativeViewCls(void)
{
  return StorylyReactNativeView.class;
}
