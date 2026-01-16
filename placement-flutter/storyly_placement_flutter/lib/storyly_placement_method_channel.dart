import 'package:flutter/services.dart';

import 'storyly_placement_platform_interface.dart';

class MethodChannelStorylyPlacementFlutter
    extends StorylyPlacementFlutterPlatform {
  final methodChannel = const MethodChannel('storyly_placement_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> createProvider(String providerId) async {
    await methodChannel.invokeMethod('createProvider', providerId);
  }

  @override
  Future<void> destroyProvider(String providerId) async {
    await methodChannel.invokeMethod('destroyProvider', providerId);
  }

  @override
  Future<void> updateConfig(String providerId, String configJson) async {
    await methodChannel.invokeMethod('updateConfig', {
      'providerId': providerId,
      'config': configJson,
    });
  }

  @override
  Future<void> hydrateProducts(String providerId, String productsJson) async {
    await methodChannel.invokeMethod('hydrateProducts', {
      'providerId': providerId,
      'products': productsJson,
    });
  }

  @override
  Future<void> hydrateWishlist(String providerId, String productsJson) async {
    await methodChannel.invokeMethod('hydrateWishlist', {
      'providerId': providerId,
      'products': productsJson,
    });
  }

  @override
  Future<void> updateCart(String providerId, String cartJson) async {
    await methodChannel.invokeMethod('updateCart', {
      'providerId': providerId,
      'cart': cartJson,
    });
  }

  @override
  void setMethodCallHandler(
    Future<dynamic> Function(String method, dynamic arguments)? handler,
  ) {
    if (handler == null) {
      methodChannel.setMethodCallHandler(null);
    } else {
      methodChannel.setMethodCallHandler(
        (call) => handler(call.method, call.arguments),
      );
    }
  }
}
