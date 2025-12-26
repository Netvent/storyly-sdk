import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'storyly_placement_platform_interface.dart';
import 'data/config.dart';
import 'data/product.dart';
import 'data/events/provider.dart';

export 'data/config.dart';
export 'data/product.dart';
export 'data/util.dart';
export 'data/events/payloads.dart';
export 'data/events/placement.dart';
export 'data/events/provider.dart';
export 'data/widgets/banner.dart';
export 'data/widgets/story_bar.dart';
export 'data/widgets/swipe_card.dart';
export 'data/widgets/video_feed.dart';
export 'storyly_placement_view.dart';
export 'storyly_placement_controller.dart';


typedef PlacementLoadCallback = void Function(PlacementLoadEvent event);
typedef PlacementLoadFailCallback = void Function(PlacementLoadFailEvent event);
typedef PlacementHydrationCallback = void Function(PlacementHydrationEvent event);

class StorylyPlacementListener {
  final PlacementLoadCallback? onLoad;
  final PlacementLoadFailCallback? onLoadFail;
  final PlacementHydrationCallback? onHydration;

  const StorylyPlacementListener({
    this.onLoad,
    this.onLoadFail,
    this.onHydration,
  });
}
class StorylyPlacementProvider {
  static int _providerIdCounter = 0;
  static final Map<String, StorylyPlacementProvider> _providers = {};
  static bool _handlerRegistered = false;

  final String _providerId;
  String get providerId => _providerId;

  StorylyPlacementListener? _listener;

  bool _disposed = false;

  StorylyPlacementProvider._({
    required String providerId,
  }): _providerId = providerId;


  static Future<StorylyPlacementProvider> create({StorylyPlacementConfig? config, StorylyPlacementListener? listener}) async {
    final providerId =
        'provider_${_providerIdCounter++}_${DateTime.now().millisecondsSinceEpoch}';

    await StorylyPlacementFlutterPlatform.instance.createProvider(providerId);
    final provider = StorylyPlacementProvider._(
      providerId: providerId
    );
    _providers[providerId] = provider;
    _ensureMethodHandlerRegistered();
    if (config != null) {
      await provider.initialize(config: config, listener: listener);
    }
    return provider;
  }


  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;

    _providers.remove(_providerId);

    await StorylyPlacementFlutterPlatform.instance
        .destroyProvider(_providerId);

    if (_providers.isEmpty) {
      StorylyPlacementFlutterPlatform.instance.setMethodCallHandler(null);
      _handlerRegistered = false;
    }
  }

  Future<void> initialize({required StorylyPlacementConfig config, StorylyPlacementListener? listener}) {
    _listener = listener;
    return StorylyPlacementFlutterPlatform.instance.updateConfig(
      _providerId,
      jsonEncode(config.toJson()),
    );
  }

  Future<void> hydrateProducts(List<STRProductItem> products) {
    return StorylyPlacementFlutterPlatform.instance.hydrateProducts(
      _providerId,
      jsonEncode({
        'products': products.map((e) => e.toJson()).toList(),
      }),
    );
  }

  Future<void> hydrateWishlist(List<STRProductItem> products) {
    return StorylyPlacementFlutterPlatform.instance.hydrateWishlist(
      _providerId,
      jsonEncode({
        'products': products.map((e) => e.toJson()).toList(),
      }),
    );
  }

  Future<void> updateCart(STRCart cart) {
    return StorylyPlacementFlutterPlatform.instance.updateCart(
      _providerId,
      jsonEncode({'cart': cart.toJson()}),
    );
  }

  static void _ensureMethodHandlerRegistered() {
    if (_handlerRegistered) return;

    StorylyPlacementFlutterPlatform.instance
        .setMethodCallHandler(_methodCallHandler);

    _handlerRegistered = true;
  }

  static Future<void> _methodCallHandler(
    String method,
    dynamic arguments,
  ) async {
    final providerId = arguments['providerId'] as String?; 
    final raw = jsonDecode(arguments['raw'] as String);

    if (providerId == null) {
      debugPrint('StorylyPlacement: Invalid event payload');
      return;
    }

    final provider = _providers[providerId];
    if (provider == null || provider._disposed) return;

    try {
      final listener = provider._listener;

      switch (method) {
        case 'onLoad':
          listener?.onLoad?.call(
            PlacementLoadEvent.fromJson(raw),
          );
          break;

        case 'onLoadFail':
          listener?.onLoadFail?.call(
            PlacementLoadFailEvent.fromJson(raw),
          );
          break;

        case 'onHydration':
          listener?.onHydration?.call(
            PlacementHydrationEvent.fromJson(raw),
          );
          break;

        default:
          debugPrint('StorylyPlacement: Unknown event "$method"');
      }
    } catch (e) {
      debugPrint(
        'StorylyPlacement: Error handling event "$method": $e',
      );
    }
  }
}
