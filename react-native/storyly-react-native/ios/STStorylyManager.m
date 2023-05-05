#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_REMAP_MODULE(STStoryly, STStorylyManager, NSObject)

RCT_EXTERN_METHOD(refresh:(nonnull NSNumber *)reactTag)

RCT_EXTERN_METHOD(open:(nonnull NSNumber *)reactTag)

RCT_EXTERN_METHOD(close:(nonnull NSNumber *)reactTag)

RCT_EXTERN_METHOD(openStory:(nonnull NSNumber *)reactTag
                  payload:(nonnull NSURL *)payload)

RCT_EXTERN_METHOD(openStoryWithId:(nonnull NSNumber *)reactTag
                  storyGroupId:(nonnull NSString *)storyGroupId
                  storyId:(nonnull NSString *)storyId)

RCT_EXTERN_METHOD(setExternalData:(nonnull NSNumber *)reactTag
                  externalData:(nonnull NSArray<NSDictionary *> *)externalData)

RCT_EXTERN_METHOD(hydrateProducts:(nonnull NSNumber *)reactTag
                  products:(nonnull NSArray<NSDictionary *> *)products)

RCT_REMAP_VIEW_PROPERTY(storyly, storylyBundle, stStorylyBundle)

RCT_EXPORT_VIEW_PROPERTY(onStorylyLoaded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyLoadFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyEvent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyActionClicked, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryPresented, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryPresentFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryDismissed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyUserInteracted, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCreateCustomView, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUpdateCustomView, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyProductHydration, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyProductEvent, RCTBubblingEventBlock)

@end
