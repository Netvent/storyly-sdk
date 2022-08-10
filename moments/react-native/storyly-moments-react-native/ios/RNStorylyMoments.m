#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNStorylyMoments, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize:(NSString)token
                  withUserPayload:(NSString)userPayload)

RCT_EXTERN_METHOD(openUserStories)

RCT_EXTERN_METHOD(openStoryCreator)
@end
