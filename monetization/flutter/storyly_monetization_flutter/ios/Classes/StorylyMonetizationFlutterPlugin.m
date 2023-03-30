#import "StorylyMonetizationFlutterPlugin.h"
#if __has_include(<storyly_monetization_flutter/storyly_monetization_flutter-Swift.h>)
#import <storyly_monetization_flutter/storyly_monetization_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "storyly_monetization_flutter-Swift.h"
#endif

@implementation StorylyMonetizationFlutterPlugin : NSObject
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStorylyMonetizationFlutterPlugin registerWithRegistrar:registrar];
}
@end
