#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "StorylyReactNativeView.h"


 @interface StorylyReactNativeViewManager : RCTViewManager
 @end

 @implementation StorylyReactNativeViewManager

 RCT_EXPORT_MODULE(StorylyReactNativeView)

- (UIView *)view
{
  return [[UIView alloc] init];
}

 RCT_EXPORT_VIEW_PROPERTY(storylyConfig, NSString)

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
 RCT_EXPORT_VIEW_PROPERTY(onStorylyCartUpdated, RCTBubblingEventBlock)

 @end
