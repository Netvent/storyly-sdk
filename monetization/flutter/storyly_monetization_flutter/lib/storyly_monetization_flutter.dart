import 'package:flutter/services.dart';

class AdViewProvider {
  final String adMobAdUnitId;
  final Map<String, dynamic>? adMobAdExtras;

  AdViewProvider({required this.adMobAdUnitId, this.adMobAdExtras});

  Map<String, dynamic> toMap() {
    return {
      "adMobAdUnitId": adMobAdUnitId,
      "adMobAdExtras": adMobAdExtras,
    };
  }
}

class StorylyMonetization {
  static const MethodChannel _methodChannel = MethodChannel(
      'com.appsamurai.storyly.storyly_monetization_flutter/storyly_monetization_flutter');

  /// This function allows you to set `AdViewProvider` for `StorylyView` with view id
  static Future<void> setAdViewProvider(
      int viewId, AdViewProvider? adViewProvider) {
    return _methodChannel.invokeMethod(
      'setAdViewProvider',
      <String, dynamic>{
        'viewId': viewId,
        'adViewProvider': adViewProvider?.toMap()
      },
    );
  }
}
