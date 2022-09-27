#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTUIManager.h>

@interface RCT_EXTERN_MODULE(RNStorylyMonetization, RCTEventEmitter)

//RCT_EXTERN_METHOD(initialize:(NSString)token
//                  withUserPayload:(NSString)userPayload)
//
//RCT_EXTERN_METHOD(openUserStories)
//
//RCT_EXTERN_METHOD(openStoryCreator)

RCT_EXTERN_METHOD(setAdViewProvider: (NSNumber * _Nonnull)reactViewId
                  withTestParam: (NSString * _Nonnull)testParam)

@end
