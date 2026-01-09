#import "StorylyPlacementProvider.h"

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

#import "StorylyPlacementReactNative-Swift.h"


@implementation StorylyPlacementProvider {
    int _listenerCount;
}

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(StorylyPlacementProvider)

- (instancetype)init
{
    if (self = [super init]) {
        _listenerCount = 0;
    }
    return self;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeStorylyPlacementProviderSpecJSI>(params);
}

// MARK: - Provider Lifecycle

- (void)createProvider:(NSString *)providerId
               resolve:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject
{
    NSLog(@"[StorylyPlacementProvider] Creating provider: %@", providerId);
    
    SPPlacementProviderWrapper *wrapper = [[SPPlacementProviderManager shared] createProviderWithId:providerId];
    
    __weak StorylyPlacementProvider *weakSelf = self;
    wrapper.sendEvent = ^(NSString *id, SPPlacementProviderEventType eventType, NSString *jsonPayload) {
        if (weakSelf) {
            NSString *eventName = [NSString stringWithFormat:@"%@_%@", id, [SPEventMapper mapProviderEvent:eventType]];
            [weakSelf sendEventWithName:eventName body:jsonPayload];
        }
    };
    
    resolve(@YES);
}

- (void)destroyProvider:(NSString *)providerId
{
    NSLog(@"[StorylyPlacementProvider] Destroying provider: %@", providerId);
    [[SPPlacementProviderManager shared] destroyProviderWithId:providerId];
}

// MARK: - Configuration

- (void)updateConfig:(NSString *)providerId config:(NSString *)config
{
    NSLog(@"[StorylyPlacementProvider] Updating config for provider: %@", providerId);
    
    SPPlacementProviderWrapper *wrapper = [[SPPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper configureWithConfigJson:config];
    }
}

// MARK: - Product Hydration

- (void)hydrateProducts:(NSString *)providerId productsJson:(NSString *)productsJson
{
    NSLog(@"[StorylyPlacementProvider] Hydrating products for provider: %@", providerId);
    
    SPPlacementProviderWrapper *wrapper = [[SPPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper hydrateProductsWithProductsJson:productsJson];
    }
}

- (void)hydrateWishlist:(NSString *)providerId productsJson:(NSString *)productsJson
{
    NSLog(@"[StorylyPlacementProvider] Hydrating wishlist for provider: %@", providerId);
    
    SPPlacementProviderWrapper *wrapper = [[SPPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper hydrateWishlistWithProductsJson:productsJson];
    }
}

- (void)updateCart:(NSString *)providerId cartJson:(NSString *)cartJson
{
    NSLog(@"[StorylyPlacementProvider] Updating cart for provider: %@", providerId);
    
    SPPlacementProviderWrapper *wrapper = [[SPPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper updateCartWithCartJson:cartJson];
    }
}

// MARK: - Event Listeners

- (void)addListener:(NSString *)eventName
{
    _listenerCount++;
}

- (void)removeListeners:(double)count
{
    _listenerCount -= (int)count;
    if (_listenerCount < 0) {
        _listenerCount = 0;
    }
}

// MARK: - Event Emission

- (void)sendEventWithName:(NSString *)eventName body:(id)body
{
    if (_listenerCount == 0) {
        return;
    }
    
    // TurboModule event emission - matches Android's DeviceEventManagerModule.RCTDeviceEventEmitter
    // Events are sent to JS via the bridge's event dispatcher
    [_bridge enqueueJSCall:@"RCTDeviceEventEmitter"
                    method:@"emit"
                      args:@[eventName, body]
                completion:NULL];
}

@end

