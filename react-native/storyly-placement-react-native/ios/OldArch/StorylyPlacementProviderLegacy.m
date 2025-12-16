#import "StorylyPlacementProviderLegacy.h"
#import "StorylyPlacementReactNative-Swift.h"

@implementation StorylyPlacementProviderLegacy {
    int _listenerCount;
    BOOL _hasListeners;
}

RCT_EXPORT_MODULE(StorylyPlacementProvider)

- (instancetype)init
{
    if (self = [super init]) {
        _listenerCount = 0;
        _hasListeners = NO;
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

// MARK: - Provider Lifecycle

RCT_EXPORT_METHOD(createProvider:(NSString *)providerId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"[StorylyPlacementProviderLegacy] Creating provider: %@", providerId);
    
    RNPlacementProviderWrapper *wrapper = [[RNPlacementProviderManager shared] createProviderWithId:providerId];
    
    __weak typeof(self) weakSelf = self;
    wrapper.sendEvent = ^(NSString *id, RNPlacementProviderEventType eventType, NSString *jsonPayload) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf && strongSelf->_hasListeners) {
            NSString *eventName = [NSString stringWithFormat:@"%@_%@", id, [eventType eventName]];
            [strongSelf sendEventWithName:eventName body:jsonPayload];
        }
    };
    
    resolve(@YES);
}

RCT_EXPORT_METHOD(destroyProvider:(NSString *)providerId)
{
    NSLog(@"[StorylyPlacementProviderLegacy] Destroying provider: %@", providerId);
    [[RNPlacementProviderManager shared] destroyProviderWithId:providerId];
}

// MARK: - Configuration

RCT_EXPORT_METHOD(updateConfig:(NSString *)providerId config:(NSString *)config)
{
    NSLog(@"[StorylyPlacementProviderLegacy] Updating config for provider: %@", providerId);
    
    RNPlacementProviderWrapper *wrapper = [[RNPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper configure:config];
    }
}

// MARK: - Product Hydration

RCT_EXPORT_METHOD(hydrateProducts:(NSString *)providerId productsJson:(NSString *)productsJson)
{
    NSLog(@"[StorylyPlacementProviderLegacy] Hydrating products for provider: %@", providerId);
    
    RNPlacementProviderWrapper *wrapper = [[RNPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper hydrateProducts:productsJson];
    }
}

RCT_EXPORT_METHOD(hydrateWishlist:(NSString *)providerId productsJson:(NSString *)productsJson)
{
    NSLog(@"[StorylyPlacementProviderLegacy] Hydrating wishlist for provider: %@", providerId);
    
    RNPlacementProviderWrapper *wrapper = [[RNPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper hydrateWishlist:productsJson];
    }
}

RCT_EXPORT_METHOD(updateCart:(NSString *)providerId cartJson:(NSString *)cartJson)
{
    NSLog(@"[StorylyPlacementProviderLegacy] Updating cart for provider: %@", providerId);
    
    RNPlacementProviderWrapper *wrapper = [[RNPlacementProviderManager shared] getProviderWithId:providerId];
    if (wrapper) {
        [wrapper updateCart:cartJson];
    }
}

// MARK: - Event Emitter

- (NSArray<NSString *> *)supportedEvents
{
    // Return empty array as event names are dynamic based on provider ID
    return @[];
}

- (void)startObserving
{
    _hasListeners = YES;
}

- (void)stopObserving
{
    _hasListeners = NO;
}

RCT_EXPORT_METHOD(addListener:(NSString *)eventName)
{
    _listenerCount++;
    [super addListener:eventName];
}

RCT_EXPORT_METHOD(removeListeners:(double)count)
{
    _listenerCount -= (int)count;
    if (_listenerCount < 0) {
        _listenerCount = 0;
    }
    [super removeListeners:count];
}

@end

