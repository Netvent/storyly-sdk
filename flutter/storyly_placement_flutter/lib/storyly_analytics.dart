import 'dart:convert';

import 'storyly_placement_platform_interface.dart';
import 'data/analytics.dart';

export 'data/analytics.dart';

/// Entry point for the Storyly Analytics module.
///
/// Provides a simple API for tracking product-related analytics events
/// (e.g. product detail page views, add-to-cart, wishlist additions,
/// purchases) independently from the Storyly placement widgets.
///
/// Usage:
/// 1. Call [initialize] once with a valid [STRAnalyticsConfig] before tracking.
/// 2. Call [track] (or [trackProduct]) to record product events.
class StorylyAnalytics {
  StorylyAnalytics._();

  /// Initializes the Storyly Analytics module with the provided configuration.
  ///
  /// Must be called before any [track] calls. Calling this multiple times
  /// updates the active configuration.
  static Future<void> initialize(STRAnalyticsConfig config) {
    return StorylyPlacementFlutterPlatform.instance.analyticsInitialize(
      jsonEncode(config.toJson()),
    );
  }

  /// Tracks a product analytics event involving one or more products.
  static Future<void> track(
    STRAnalyticProductEvent event,
    List<STRAnalyticProduct> products,
  ) {
    return StorylyPlacementFlutterPlatform.instance.analyticsTrack(
      jsonEncode({
        'event': event.value,
        'products': products.map((e) => e.toJson()).toList(),
      }),
    );
  }

  /// Tracks a product analytics event involving a single product.
  ///
  /// Convenience wrapper around [track].
  static Future<void> trackProduct(
    STRAnalyticProductEvent event,
    STRAnalyticProduct product,
  ) {
    return track(event, [product]);
  }
}
