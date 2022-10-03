#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTUIManager.h>

@interface RCT_EXTERN_MODULE(RNStorylyMonetization, RCTEventEmitter)


RCT_EXTERN_METHOD(setAdViewProvider: (NSNumber * _Nonnull)reactViewId
                  withAdViewProvider: (NSDictionary *)adViewProvider)

@end
