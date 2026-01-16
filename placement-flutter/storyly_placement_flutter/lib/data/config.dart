class StorylyPlacementConfig {
  final String token;
  final bool? testMode;
  final String? locale;
  final String? layoutDirection; // 'ltr' | 'rtl'
  final String? customParameter;
  final List<String>? labels;
  final Map<String, String>? userProperties;
  final StorylyProductConfig? productConfig;
  final StorylyShareConfig? shareConfig;
  final StorylyNetworkConfig? networkConfig;

  StorylyPlacementConfig({
    required this.token,
    this.testMode,
    this.locale,
    this.layoutDirection,
    this.customParameter,
    this.labels,
    this.userProperties,
    this.productConfig,
    this.shareConfig,
    this.networkConfig,
  });

  factory StorylyPlacementConfig.fromJson(Map<String, dynamic> json) {
    return StorylyPlacementConfig(
      token: json['token'],
      testMode: json['testMode'],
      locale: json['locale'],
      layoutDirection: json['layoutDirection'],
      customParameter: json['customParameter'],
      labels: (json['labels'] as List<dynamic>?)?.cast<String>(),
      userProperties: (json['userProperties'] as Map<String, dynamic>?)
          ?.cast<String, String>(),
      productConfig: json['productConfig'] != null
          ? StorylyProductConfig.fromJson(json['productConfig'])
          : null,
      shareConfig: json['shareConfig'] != null
          ? StorylyShareConfig.fromJson(json['shareConfig'])
          : null,
      networkConfig: json['networkConfig'] != null
          ? StorylyNetworkConfig.fromJson(json['networkConfig'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'testMode': testMode,
      'locale': locale,
      'layoutDirection': layoutDirection,
      'customParameter': customParameter,
      'labels': labels,
      'userProperties': userProperties,
      'productConfig': productConfig?.toJson(),
      'shareConfig': shareConfig?.toJson(),
      'networkConfig': networkConfig?.toJson(),
    };
  }
}

class StorylyProductConfig {
  final bool? isFallbackEnabled;
  final bool? isCartEnabled;

  StorylyProductConfig({this.isFallbackEnabled, this.isCartEnabled});

  factory StorylyProductConfig.fromJson(Map<String, dynamic> json) {
    return StorylyProductConfig(
      isFallbackEnabled: json['isFallbackEnabled'],
      isCartEnabled: json['isCartEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFallbackEnabled': isFallbackEnabled,
      'isCartEnabled': isCartEnabled,
    };
  }
}

class StorylyShareConfig {
  final String? shareUrl;
  final String? facebookAppId;
  final bool? appLogoVisibility;

  StorylyShareConfig({
    this.shareUrl,
    this.facebookAppId,
    this.appLogoVisibility,
  });

  factory StorylyShareConfig.fromJson(Map<String, dynamic> json) {
    return StorylyShareConfig(
      shareUrl: json['shareUrl'],
      facebookAppId: json['facebookAppId'],
      appLogoVisibility: json['appLogoVisibility'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shareUrl': shareUrl,
      'facebookAppId': facebookAppId,
      'appLogoVisibility': appLogoVisibility,
    };
  }
}

class StorylyNetworkConfig {
  final String? cdnHost;
  final String? productHost;
  final String? analyticHost;
  final String? placementHost;

  StorylyNetworkConfig({
    this.cdnHost,
    this.productHost,
    this.analyticHost,
    this.placementHost,
  });

  factory StorylyNetworkConfig.fromJson(Map<String, dynamic> json) {
    return StorylyNetworkConfig(
      cdnHost: json['cdnHost'],
      productHost: json['productHost'],
      analyticHost: json['analyticHost'],
      placementHost: json['placementHost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cdnHost': cdnHost,
      'productHost': productHost,
      'analyticHost': analyticHost,
      'placementHost': placementHost,
    };
  }
}
