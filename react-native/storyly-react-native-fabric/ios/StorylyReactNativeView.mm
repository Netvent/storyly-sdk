//
//  StorylyReactNativeView.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 20.09.2023.
//

#import "StorylyReactNativeView.h"

#import <react/renderer/components/storylyfabric/ComponentDescriptors.h>
#import <react/renderer/components/storylyfabric/EventEmitters.h>
#import <react/renderer/components/storylyfabric/Props.h>
#import <react/renderer/components/storylyfabric/RCTComponentViewHelpers.h>

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
      _stStorylyView.onStorylyLoaded = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyLoaded(StorylyReactNativeViewEventEmitter::OnStorylyLoaded{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyLoadFailed = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyLoadFailed(StorylyReactNativeViewEventEmitter::OnStorylyLoadFailed{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyProductEvent = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyEvent(StorylyReactNativeViewEventEmitter::OnStorylyEvent{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyStoryPresented = ^() {
          [weakSelf storylyEventEmitter]
            ->onStorylyStoryPresented(StorylyReactNativeViewEventEmitter::OnStorylyStoryPresented{});
      };
      _stStorylyView.onStorylyStoryPresentFailed = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyStoryPresentFailed(StorylyReactNativeViewEventEmitter::OnStorylyStoryPresentFailed{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyActionClicked = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyActionClicked(StorylyReactNativeViewEventEmitter::OnStorylyActionClicked{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyUserInteracted = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyUserInteracted(StorylyReactNativeViewEventEmitter::OnStorylyUserInteracted{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyProductHydration = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyProductHydration(StorylyReactNativeViewEventEmitter::OnStorylyProductHydration{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyCartUpdated = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyCartUpdated(StorylyReactNativeViewEventEmitter::OnStorylyCartUpdated{std::string([raw UTF8String])});
      };
      _stStorylyView.onStorylyProductEvent = ^(NSString* raw) {
          [weakSelf storylyEventEmitter]
            ->onStorylyProductEvent(StorylyReactNativeViewEventEmitter::OnStorylyProductEvent{std::string([raw UTF8String])});
      };
      
      self.contentView = _stStorylyView;
      
     NSLog([NSString stringWithFormat:@"StorylyReactNativeView:initWithFrame: %@", _stStorylyView]);
  }

  return self;
}

- (std::shared_ptr<const StorylyReactNativeViewEventEmitter>)storylyEventEmitter
{
    return std::dynamic_pointer_cast<const StorylyReactNativeViewEventEmitter>(_eventEmitter);
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
        NSLog([NSString stringWithFormat:@"invalid commandName: %@", commandName]);
    }
    
    [super handleCommand:commandName args:args];
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
