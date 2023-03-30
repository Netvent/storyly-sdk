#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNStorylyMoments, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize:(NSString)token
                  withUserPayload:(NSString)userPayload)

RCT_EXTERN_METHOD(openUserStories)

RCT_EXTERN_METHOD(openStoryCreator)

RCT_EXTERN_METHOD(encryptUserPayload:(NSString)secretKey
                  withInitializationVector:(NSString)initializationVector
                  withId:(NSString)id
                  withUsername:(NSString)username
                  withAvatarUrl:(NSString)avatarUrl
                  withFollowings:(NSArray)followings
                  withCreatorTags:(nullable NSArray *)creatorTags
                  withConsumerTags:(nullable NSArray *)consumerTags
                  withExpirationTime:(NSInteger)expirationTime
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
@end
