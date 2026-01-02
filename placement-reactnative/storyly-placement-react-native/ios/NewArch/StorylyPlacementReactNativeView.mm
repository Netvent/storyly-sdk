#import "StorylyPlacementReactNativeView.h"

#import <react/renderer/components/StorylyPlacementReactNativeViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/StorylyPlacementReactNativeViewSpec/EventEmitters.h>
#import <react/renderer/components/StorylyPlacementReactNativeViewSpec/Props.h>
#import <react/renderer/components/StorylyPlacementReactNativeViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "StorylyPlacementReactNative-Swift.h"

using namespace facebook::react;

@interface StorylyPlacementReactNativeView () <RCTStorylyPlacementReactNativeViewViewProtocol>
@end

@implementation StorylyPlacementReactNativeView {
    RNStorylyPlacementView * _swiftView;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<StorylyPlacementReactNativeViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const StorylyPlacementReactNativeViewProps>();
        _props = defaultProps;

        _swiftView = [[RNStorylyPlacementView alloc] initWithFrame:self.bounds];
        
        // Set up event dispatcher
        __weak StorylyPlacementReactNativeView *weakSelf = self;
        _swiftView.dispatchEvent = ^(RNPlacementEventType eventType, NSString * _Nullable payload) {
            if (weakSelf) {
                [weakSelf dispatchEvent:eventType payload:payload];
            }
        };
        
        self.contentView = _swiftView;
    }

    return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<StorylyPlacementReactNativeViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<StorylyPlacementReactNativeViewProps const>(props);

//     Handle providerId prop
    if (oldViewProps.providerId != newViewProps.providerId) {
        NSString *providerId = [[NSString alloc] initWithUTF8String:newViewProps.providerId.c_str()];
        [_swiftView configureWithProviderId:providerId];
    }

    [super updateProps:props oldProps:oldProps];
}

- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args
{
    RCTStorylyPlacementReactNativeViewHandleCommand(self, commandName, args);
}

// MARK: - Command Handlers

- (void)callWidget:(NSString *)widgetId method:(NSString *)method raw:(NSString *)raw
{
    [_swiftView callWidgetWithId:widgetId method:method raw:raw];
}

- (void)approveCartChange:(NSString *)responseId raw:(NSString *)raw
{
    [_swiftView approveCartChangeWithResponseId:responseId raw:raw];
}

- (void)rejectCartChange:(NSString *)responseId raw:(NSString *)raw
{
    [_swiftView rejectCartChangeWithResponseId:responseId raw:raw];
}

- (void)approveWishlistChange:(NSString *)responseId raw:(NSString *)raw
{
    [_swiftView approveWishlistChangeWithResponseId:responseId raw:raw];
}

- (void)rejectWishlistChange:(NSString *)responseId raw:(NSString *)raw
{
    [_swiftView rejectWishlistChangeWithResponseId:responseId raw:raw];
}

// MARK: - Event Dispatching

- (void)dispatchEvent:(RNPlacementEventType)eventType payload:(NSString * _Nullable)payload
{
    if (!_eventEmitter) { return; }
    
    auto emitter = std::static_pointer_cast<const StorylyPlacementReactNativeViewEventEmitter>(_eventEmitter);
    if (!emitter) { return; }

    switch (eventType) {
      case RNPlacementEventTypeOnWidgetReady: {
        StorylyPlacementReactNativeViewEventEmitter::OnWidgetReady widgetReadyData = {
            .raw = payload ? std::string([payload UTF8String]) : std::string("")
        };
        emitter->onWidgetReady(widgetReadyData);
        break;
      }
        
      case RNPlacementEventTypeOnFail: {
        StorylyPlacementReactNativeViewEventEmitter::OnFail failData = {
            .raw = payload ? std::string([payload UTF8String]) : std::string("")
        };
        emitter->onFail(failData);
        break;
      }
            
      case RNPlacementEventTypeOnEvent: {
        StorylyPlacementReactNativeViewEventEmitter::OnEvent eventData = {
            .raw = payload ? std::string([payload UTF8String]) : std::string("")
        };
        emitter->onEvent(eventData);
        break;
      }
      case RNPlacementEventTypeOnActionClicked: {
        StorylyPlacementReactNativeViewEventEmitter::OnActionClicked actionClickedData = {
            .raw = payload ? std::string([payload UTF8String]) : std::string("")
        };
        emitter->onActionClicked(actionClickedData);
        break;
      }
      case RNPlacementEventTypeOnProductEvent: {
        StorylyPlacementReactNativeViewEventEmitter::OnProductEvent productEventData = {
            .raw = payload ? std::string([payload UTF8String]) : std::string("")
        };
        emitter->onProductEvent(productEventData);
        break;
      }
      case RNPlacementEventTypeOnUpdateCart: {
        StorylyPlacementReactNativeViewEventEmitter::OnUpdateCart updateCartData = {
            .raw = payload ? std::string([payload UTF8String]) : std::string("")
        };
        emitter->onUpdateCart(updateCartData);
        break;
      }
      case RNPlacementEventTypeOnUpdateWishlist: {
        StorylyPlacementReactNativeViewEventEmitter::OnUpdateWishlist updateWishlistData = {
            .raw = payload ? std::string([payload UTF8String]) : std::string("")
        };
        emitter->onUpdateWishlist(updateWishlistData);
        break;
      }
    }
}

Class<RCTComponentViewProtocol> StorylyPlacementReactNativeViewCls(void)
{
    return StorylyPlacementReactNativeView.class;
}

@end

