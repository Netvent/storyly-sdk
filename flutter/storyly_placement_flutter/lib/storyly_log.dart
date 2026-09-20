import 'storyly_placement_platform_interface.dart';

/// Log levels for Storyly Placement. [off] is the default.
enum STRLogLevel {
  debug,
  warning,
  error,
  off,
}

/// Log level control for the placement SDK.
///
/// Logs are off by default. Setting a level applies to both the
/// cross-platform wrapper and the native Storyly Placement SDK.
class StorylyLog {
  StorylyLog._();

  /// Sets the minimum log level for Storyly Placement.
  /// [STRLogLevel.debug] is the most verbose, [STRLogLevel.off] (default)
  /// silences all output.
  static Future<void> setLogLevel(STRLogLevel level) {
    return StorylyPlacementFlutterPlatform.instance.setLogLevel(level.name);
  }
}
