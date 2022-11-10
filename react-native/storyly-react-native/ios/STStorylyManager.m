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


RCT_REMAP_VIEW_PROPERTY(storylyInit, storylyView.storylyInit, stStorylyInit)
RCT_REMAP_VIEW_PROPERTY(storylyShareUrl, storylyView.storylyShareUrl, NSString)

RCT_REMAP_VIEW_PROPERTY(storyGroupIconBorderColorSeen, storylyView.storyGroupIconBorderColorSeen, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyGroupIconBorderColorNotSeen, storylyView.storyGroupIconBorderColorNotSeen, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyGroupIconBackgroundColor, storylyView.storyGroupIconBackgroundColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupTextColorSeen, storylyView.storyGroupTextColorSeen, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupTextColorNotSeen, storylyView.storyGroupTextColorNotSeen, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupPinIconColor, storylyView.storyGroupPinIconColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupSize, storylyView.storyGroupSize, NSString)
RCT_REMAP_VIEW_PROPERTY(storyItemIconBorderColor, storylyView.storyItemIconBorderColor, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyItemTextColor, storylyView.storyItemTextColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyItemProgressBarColor, storylyView.storylyItemProgressBarColor, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyItemTextTypeface, storylyView.storyItemTextFont, stStoryItemTextTypeface)
RCT_REMAP_VIEW_PROPERTY(storyInteractiveTextTypeface, storylyView.storyInteractiveFont, stStoryInteractiveTextTypeface)
RCT_REMAP_VIEW_PROPERTY(storyGroupIconStyling, storylyView.storyGroupIconStyling, stStoryGroupIconStyling)
RCT_REMAP_VIEW_PROPERTY(storyGroupListStyling, storylyView.storyGroupListStyling, stStoryGroupListStyling)
RCT_REMAP_VIEW_PROPERTY(storyGroupTextStyling, storylyView.storyGroupTextStyling, stStoryGroupTextStyling)
RCT_REMAP_VIEW_PROPERTY(storyHeaderStyling, storylyView.storyHeaderStyling, stStoryHeaderStyling)
RCT_REMAP_VIEW_PROPERTY(storylyLayoutDirection, storylyView.storylyLayoutDirection, stStorylyLayoutDirection)
RCT_REMAP_VIEW_PROPERTY(storyGroupViewFactory, storyGroupViewFactorySize, stStoryGroupViewFactory)

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

@end
