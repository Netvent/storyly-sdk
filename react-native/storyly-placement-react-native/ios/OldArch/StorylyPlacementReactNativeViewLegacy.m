#import "StorylyPlacementReactNativeViewLegacy.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUIManager.h>
#import <StorylyPlacementReactNative/StorylyPlacementReactNative-Swift.h>

@implementation StorylyPlacementReactNativeViewLegacy

RCT_EXPORT_MODULE(StorylyPlacementReactNativeViewLegacy)

- (UIView *)view
{
    RNStorylyPlacementView *view = [[RNStorylyPlacementView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(view) weakView = view;
    
    view.dispatchEvent = ^(RNPlacementEventType eventType, NSString * _Nullable payload) {
        if (weakSelf && weakView) {
            NSDictionary *eventData = @{};
            if (payload) {
                eventData = @{@"raw": payload};
            }
            
          [weakSelf.bridge.eventDispatcher sendAppEventWithName:[RNEventMapper mapPlacementEvent: eventType] body:eventData];
        }
    };
    
    return view;
}

// MARK: - Props

RCT_CUSTOM_VIEW_PROPERTY(providerId, NSString, RNStorylyPlacementView)
{
    NSString *providerId = [RCTConvert NSString:json];
    if (providerId) {
        [view configureWithProviderId: providerId];
    }
}

// MARK: - Commands

RCT_EXPORT_METHOD(callWidget:(nonnull NSNumber *)reactTag
                  widgetId:(NSString *)widgetId
                  method:(NSString *)method
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNStorylyPlacementView *view = (RNStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[RNStorylyPlacementView class]]) {
            [view callWidgetWithId:widgetId method:method raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(approveCartChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNStorylyPlacementView *view = (RNStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[RNStorylyPlacementView class]]) {
            [view approveCartChangeWithResponseId:responseId raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(rejectCartChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNStorylyPlacementView *view = (RNStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[RNStorylyPlacementView class]]) {
            [view rejectCartChangeWithResponseId:responseId raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(approveWishlistChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNStorylyPlacementView *view = (RNStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[RNStorylyPlacementView class]]) {
            [view approveWishlistChangeWithResponseId:responseId raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(rejectWishlistChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNStorylyPlacementView *view = (RNStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[RNStorylyPlacementView class]]) {
            [view rejectWishlistChangeWithResponseId:responseId raw:raw];
        }
    }];
}

// MARK: - Events

- (NSArray<NSString *> *)customDirectEventTypes
{
  return [RNEventMapper allPlacementEvents];
}

@end

