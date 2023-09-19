#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"

@interface StorylyReactNativeViewManager : RCTViewManager
@end

@implementation StorylyReactNativeViewManager

RCT_EXPORT_MODULE(StorylyReactNativeView)

- (UIView *)view
{
  return [[UIView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end
