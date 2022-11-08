#import "STStorylyManager.h"

@implementation STStorylyManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    return [STStorylyView new];
}

RCT_EXPORT_METHOD(refresh:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, STStorylyView *> *viewRegistry) {
        STStorylyView *stStorylyView = viewRegistry[reactTag];
        if (![stStorylyView isKindOfClass:[STStorylyView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting STStorylyView, got: %@", stStorylyView);
        } else {
            [stStorylyView refresh];
        }
    }];
}

RCT_EXPORT_METHOD(open:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, STStorylyView *> *viewRegistry) {
        STStorylyView *stStorylyView = viewRegistry[reactTag];
        if (![stStorylyView isKindOfClass:[STStorylyView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting STStorylyView, got: %@", stStorylyView);
        } else {
            [stStorylyView open];
        }
    }];
}

RCT_EXPORT_METHOD(close:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, STStorylyView *> *viewRegistry) {
        STStorylyView *stStorylyView = viewRegistry[reactTag];
        if (![stStorylyView isKindOfClass:[STStorylyView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting STStorylyView, got: %@", stStorylyView);
        } else {
            [stStorylyView close];
        }
    }];
}

RCT_EXPORT_METHOD(openStory:(nonnull NSNumber *)reactTag
                  payload:(nonnull NSURL *)payload)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, STStorylyView *> *viewRegistry) {
        STStorylyView *stStorylyView = viewRegistry[reactTag];
        if (![stStorylyView isKindOfClass:[STStorylyView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting STStorylyView, got: %@", stStorylyView);
        } else {
            [stStorylyView openStory:payload];
        }
    }];
}

RCT_EXPORT_METHOD(openStoryWithId:(nonnull NSNumber *)reactTag
                  storyGroupId:(nonnull NSString *)storyGroupId
                  storyId:(nonnull NSString *)storyId)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, STStorylyView *> *viewRegistry) {
        STStorylyView *stStorylyView = viewRegistry[reactTag];
        if (![stStorylyView isKindOfClass:[STStorylyView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting STStorylyView, got: %@", stStorylyView);
        } else {
            [stStorylyView openStoryWithId:storyGroupId storyId:storyId];
        }
    }];
}

RCT_EXPORT_METHOD(setExternalData:(nonnull NSNumber *)reactTag
                  externalData:(nonnull NSArray<NSDictionary *> *)externalData)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, STStorylyView *> *viewRegistry) {
        STStorylyView *stStorylyView = viewRegistry[reactTag];
        if (![stStorylyView isKindOfClass:[STStorylyView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting STStorylyView, got: %@", stStorylyView);
        } else {
            [stStorylyView setExternalData:externalData];
        }
    }];
}

RCT_REMAP_VIEW_PROPERTY(storylyInit, _storylyView.storylyInit, STStorylyInit)
RCT_REMAP_VIEW_PROPERTY(storylyShareUrl, _storylyView.storylyShareUrl, NSString)

RCT_REMAP_VIEW_PROPERTY(storyGroupIconBorderColorSeen, _storylyView.storyGroupIconBorderColorSeen, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyGroupIconBorderColorNotSeen, _storylyView.storyGroupIconBorderColorNotSeen, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyGroupIconBackgroundColor, _storylyView.storyGroupIconBackgroundColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupTextColorSeen, _storylyView.storyGroupTextColorSeen, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupTextColorNotSeen, _storylyView.storyGroupTextColorNotSeen, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupPinIconColor, _storylyView.storyGroupPinIconColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyGroupSize, _storylyView.storyGroupSize, NSString)
RCT_REMAP_VIEW_PROPERTY(storyItemIconBorderColor, _storylyView.storyItemIconBorderColor, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyItemTextColor, _storylyView.storyItemTextColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(storyItemProgressBarColor, _storylyView.storylyItemProgressBarColor, NSArray<UIColor *>)
RCT_REMAP_VIEW_PROPERTY(storyItemTextTypeface, _storylyView.storyItemTextFont, STStoryItemTextTypeface)
RCT_REMAP_VIEW_PROPERTY(storyInteractiveTextTypeface, _storylyView.storyInteractiveFont, STStoryInteractiveTextTypeface)
RCT_REMAP_VIEW_PROPERTY(storyGroupIconStyling, _storylyView.storyGroupIconStyling, STStoryGroupIconStyling)
RCT_REMAP_VIEW_PROPERTY(storyGroupListStyling, _storylyView.storyGroupListStyling, STStoryGroupListStyling)
RCT_REMAP_VIEW_PROPERTY(storyGroupTextStyling, _storylyView.storyGroupTextStyling, STStoryGroupTextStyling)
RCT_REMAP_VIEW_PROPERTY(storyHeaderStyling, _storylyView.storyHeaderStyling, STStoryHeaderStyling)
RCT_REMAP_VIEW_PROPERTY(storylyLayoutDirection, _storylyView.storylyLayoutDirection, STStorylyLayoutDirection)

RCT_EXPORT_VIEW_PROPERTY(onStorylyLoaded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyLoadFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyEvent, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyActionClicked, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryPresented, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryPresentFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyStoryDismissed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStorylyUserInteracted, RCTBubblingEventBlock)

@end
