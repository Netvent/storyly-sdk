#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_REMAP_MODULE(STVerticalFeedPresenter, STVerticalFeedPresenterManager, NSObject)

RCT_EXTERN_METHOD(refresh:(nonnull NSNumber *)reactTag)

RCT_EXTERN_METHOD(openStory:(nonnull NSNumber *)reactTag
                  payload:(nonnull NSURL *)payload)

RCT_EXTERN_METHOD(openStoryWithId:(nonnull NSNumber *)reactTag
                  storyGroupId:(nonnull NSString *)storyGroupId
                  storyId:(NSString *)storyId
                  playMode:(NSString *)playMode
                  )

RCT_EXTERN_METHOD(hydrateProducts:(nonnull NSNumber *)reactTag
                  products:(nonnull NSArray<NSDictionary *> *)products)

RCT_EXTERN_METHOD(updateCart:(nonnull NSNumber *)reactTag
                  cart:(nonnull NSDictionary * *)cart)

RCT_EXTERN_METHOD(approveCartChange:(nonnull NSNumber *)reactTag
                  responseId:(nonnull NSString *)responseId
                  cart:(NSDictionary * *)cart)

RCT_EXTERN_METHOD(rejectCartChange:(nonnull NSNumber *)reactTag
                  responseId:(nonnull NSString *)responseId
                  failMessage:(nonnull NSString *)failMessage)

RCT_EXTERN_METHOD(approveWishlistChange:(nonnull NSNumber *)reactTag
                  responseId:(nonnull NSString *)responseId
                  item:(NSDictionary * *)item)

RCT_EXTERN_METHOD(rejectWishlistChange:(nonnull NSNumber *)reactTag
                  responseId:(nonnull NSString *)responseId
                  failMessage:(nonnull NSString *)failMessage)
                  
RCT_EXTERN_METHOD(resumeStory:(nonnull NSNumber *)reactTag)

RCT_EXTERN_METHOD(pauseStory:(nonnull NSNumber *)reactTag)

RCT_EXTERN_METHOD(closeStory:(nonnull NSNumber *)reactTag)

RCT_REMAP_VIEW_PROPERTY(storyly, storylyBundle, stVerticalFeedPresenterBundle)

RCT_EXPORT_VIEW_PROPERTY(onStorylyLoaded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyLoadFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyEvent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyActionClicked, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryPresented, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryPresentFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryDismissed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyUserInteracted, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyProductHydration, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyProductEvent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyCartUpdated, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyWishlistUpdated, RCTBubblingEventBlock)

@end
