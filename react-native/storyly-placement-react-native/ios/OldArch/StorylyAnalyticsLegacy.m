#import "StorylyAnalyticsLegacy.h"

#import "StorylyPlacementReactNative-Swift.h"

@implementation StorylyAnalyticsLegacy

RCT_EXPORT_MODULE(StorylyAnalytics)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_METHOD(initialize:(NSString *)config)
{
    NSLog(@"[StorylyAnalyticsLegacy] initialize");
    [[SPAnalyticsManager shared] initializeWithConfigJson:config];
}

RCT_EXPORT_METHOD(track:(NSString *)event)
{
    NSLog(@"[StorylyAnalyticsLegacy] track");
    [[SPAnalyticsManager shared] trackWithEventJson:event];
}

@end
