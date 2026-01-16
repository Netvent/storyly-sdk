#import "StorylyPlacementReactNativeViewLegacy.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUIManager.h>
#import <React/RCTComponent.h>

#import "StorylyPlacementReactNative-Swift.h"

// Macro to generate event property setter and getter using associated objects
#define RN_BUBBLING_EVENT_PROPERTY(CapitalizedName, lowercaseName) \
- (void)set##CapitalizedName:(RCTBubblingEventBlock)lowercaseName { \
    objc_setAssociatedObject(self, @selector(lowercaseName), lowercaseName, OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (RCTBubblingEventBlock)lowercaseName { \
    return objc_getAssociatedObject(self, @selector(lowercaseName)); \
}

// Category to add event properties to SPStorylyPlacementView (OldArch only)
@interface SPStorylyPlacementView (EventProps)
@property (nonatomic, copy) RCTBubblingEventBlock onWidgetReady;
@property (nonatomic, copy) RCTBubblingEventBlock onFail;
@property (nonatomic, copy) RCTBubblingEventBlock onEvent;
@property (nonatomic, copy) RCTBubblingEventBlock onActionClicked;
@property (nonatomic, copy) RCTBubblingEventBlock onProductEvent;
@property (nonatomic, copy) RCTBubblingEventBlock onUpdateCart;
@property (nonatomic, copy) RCTBubblingEventBlock onUpdateWishlist;
@end

@implementation SPStorylyPlacementView (EventProps)

RN_BUBBLING_EVENT_PROPERTY(OnWidgetReady, onWidgetReady)
RN_BUBBLING_EVENT_PROPERTY(OnFail, onFail)
RN_BUBBLING_EVENT_PROPERTY(OnEvent, onEvent)
RN_BUBBLING_EVENT_PROPERTY(OnActionClicked, onActionClicked)
RN_BUBBLING_EVENT_PROPERTY(OnProductEvent, onProductEvent)
RN_BUBBLING_EVENT_PROPERTY(OnUpdateCart, onUpdateCart)
RN_BUBBLING_EVENT_PROPERTY(OnUpdateWishlist, onUpdateWishlist)

@end

@implementation StorylyPlacementReactNativeViewLegacy

RCT_EXPORT_MODULE(StorylyPlacementReactNativeViewLegacy)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (UIView *)view
{
    SPStorylyPlacementView *view = [[SPStorylyPlacementView alloc] init];
    
    __weak typeof(view) weakView = view;
    view.dispatchEvent = ^(SPPlacementEventType eventType, NSString * _Nullable payload) {
        __strong typeof(weakView) strongView = weakView;
        if (!strongView) return;
        
        NSDictionary *eventData = @{};
        if (payload) {
            eventData = @{@"raw": payload};
        }
        
        switch (eventType) {
            case SPPlacementEventTypeOnWidgetReady:
                if (strongView.onWidgetReady) strongView.onWidgetReady(eventData);
                break;
            case SPPlacementEventTypeOnFail:
                if (strongView.onFail) strongView.onFail(eventData);
                break;
            case SPPlacementEventTypeOnEvent:
                if (strongView.onEvent) strongView.onEvent(eventData);
                break;
            case SPPlacementEventTypeOnActionClicked:
                if (strongView.onActionClicked) strongView.onActionClicked(eventData);
                break;
            case SPPlacementEventTypeOnProductEvent:
                if (strongView.onProductEvent) strongView.onProductEvent(eventData);
                break;
            case SPPlacementEventTypeOnUpdateCart:
                if (strongView.onUpdateCart) strongView.onUpdateCart(eventData);
                break;
            case SPPlacementEventTypeOnUpdateWishlist:
                if (strongView.onUpdateWishlist) strongView.onUpdateWishlist(eventData);
                break;
        }
    };
    
    return view;
}

// MARK: - Event Properties
RCT_EXPORT_VIEW_PROPERTY(onWidgetReady, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFail, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEvent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onActionClicked, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onProductEvent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUpdateCart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUpdateWishlist, RCTBubblingEventBlock)

// MARK: - Props
RCT_CUSTOM_VIEW_PROPERTY(providerId, NSString, SPStorylyPlacementView)
{
    NSString *providerId = [RCTConvert NSString:json];
    if (providerId) {
        [view configureWithProviderId:providerId];
    }
}

// MARK: - Commands

RCT_EXPORT_METHOD(callWidget:(nonnull NSNumber *)reactTag
                  widgetId:(NSString *)widgetId
                  method:(NSString *)method
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        SPStorylyPlacementView *view = (SPStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[SPStorylyPlacementView class]]) {
            [view callWidgetWithId:widgetId method:method raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(approveCartChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        SPStorylyPlacementView *view = (SPStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[SPStorylyPlacementView class]]) {
            [view approveCartChangeWithResponseId:responseId raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(rejectCartChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        SPStorylyPlacementView *view = (SPStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[SPStorylyPlacementView class]]) {
            [view rejectCartChangeWithResponseId:responseId raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(approveWishlistChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        SPStorylyPlacementView *view = (SPStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[SPStorylyPlacementView class]]) {
            [view approveWishlistChangeWithResponseId:responseId raw:raw];
        }
    }];
}

RCT_EXPORT_METHOD(rejectWishlistChange:(nonnull NSNumber *)reactTag
                  responseId:(NSString *)responseId
                  raw:(NSString *)raw)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        SPStorylyPlacementView *view = (SPStorylyPlacementView *)viewRegistry[reactTag];
        if ([view isKindOfClass:[SPStorylyPlacementView class]]) {
            [view rejectWishlistChangeWithResponseId:responseId raw:raw];
        }
    }];
}

@end

