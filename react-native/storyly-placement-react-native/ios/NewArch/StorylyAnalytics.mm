#import "StorylyAnalytics.h"

#import "StorylyPlacementReactNative-Swift.h"


@implementation StorylyAnalytics

RCT_EXPORT_MODULE(StorylyAnalytics)

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeStorylyAnalyticsSpecJSI>(params);
}

- (void)initialize:(NSString *)config
{
    NSLog(@"[StorylyAnalytics] initialize");
    [[SPAnalyticsManager shared] initializeWithConfigJson:config];
}

- (void)track:(NSString *)event
{
    NSLog(@"[StorylyAnalytics] track");
    [[SPAnalyticsManager shared] trackWithEventJson:event];
}

@end
