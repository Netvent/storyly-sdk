#import "StorylyFlutterPlugin.h"
#if __has_include(<storyly_flutter/storyly_flutter-Swift.h>)
#import <storyly_flutter/storyly_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "storyly_flutter-Swift.h"
#endif

@implementation StorylyFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStorylyFlutterPlugin registerWithRegistrar:registrar];
}
@end    
