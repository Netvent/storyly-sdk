import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'storyly_placement_method_channel.dart';

abstract class StorylyPlacementFlutterPlatform extends PlatformInterface {
  StorylyPlacementFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static StorylyPlacementFlutterPlatform _instance = MethodChannelStorylyPlacementFlutter();


  static StorylyPlacementFlutterPlatform get instance => _instance;

  static set instance(StorylyPlacementFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> createProvider(String providerId) {
    throw UnimplementedError('createProvider() has not been implemented.');
  }

  Future<void> destroyProvider(String providerId) {
    throw UnimplementedError('destroyProvider() has not been implemented.');
  }

  Future<void> updateConfig(String providerId, String configJson) {
    throw UnimplementedError('updateConfig() has not been implemented.');
  }

  Future<void> hydrateProducts(String providerId, String productsJson) {
    throw UnimplementedError('hydrateProducts() has not been implemented.');
  }

  Future<void> hydrateWishlist(String providerId, String productsJson) {
    throw UnimplementedError('hydrateWishlist() has not been implemented.');
  }

  Future<void> updateCart(String providerId, String cartJson) {
    throw UnimplementedError('updateCart() has not been implemented.');
  }

  /// Sets the callback for receiving method calls from the native platform.
  void setMethodCallHandler(Future<dynamic> Function(String method, dynamic arguments)? handler) {
    throw UnimplementedError('setMethodCallHandler() has not been implemented.');
  }
}
