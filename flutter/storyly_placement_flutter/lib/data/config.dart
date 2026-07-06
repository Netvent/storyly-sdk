class STRPlacementConfig {
  final String token;
  final bool? testMode;
  final String? locale;
  final String? layoutDirection; // 'ltr' | 'rtl'
  final String? theme; // 'dark' | 'light'
  final String? customParameter;
  final List<String>? labels;
  final Map<String, String>? userProperties;
  final STRProductConfig? productConfig;
  final STRShareConfig? shareConfig;
  final STRNetworkConfig? networkConfig;

  STRPlacementConfig({
    required this.token,
    this.testMode,
    this.locale,
    this.layoutDirection,
    this.theme,
    this.customParameter,
    this.labels,
    this.userProperties,
    this.productConfig,
    this.shareConfig,
    this.networkConfig,
  });

  factory STRPlacementConfig.fromJson(Map<String, dynamic> json) {
    return STRPlacementConfig(
      token: json['token'],
      testMode: json['testMode'],
      locale: json['locale'],
      layoutDirection: json['layoutDirection'],
      theme: json['theme'],
      customParameter: json['customParameter'],
      labels: (json['labels'] as List<dynamic>?)?.cast<String>(),
      userProperties: (json['userProperties'] as Map<String, dynamic>?)
          ?.cast<String, String>(),
      productConfig: json['productConfig'] != null
          ? STRProductConfig.fromJson(json['productConfig'])
          : null,
      shareConfig: json['shareConfig'] != null
          ? STRShareConfig.fromJson(json['shareConfig'])
          : null,
      networkConfig: json['networkConfig'] != null
          ? STRNetworkConfig.fromJson(json['networkConfig'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'testMode': testMode,
      'locale': locale,
      'layoutDirection': layoutDirection,
      'theme': theme,
      'customParameter': customParameter,
      'labels': labels,
      'userProperties': userProperties,
      'productConfig': productConfig?.toJson(),
      'shareConfig': shareConfig?.toJson(),
      'networkConfig': networkConfig?.toJson(),
    };
  }
}

class STRProductConfig {
  STRProductConfig();

  factory STRProductConfig.fromJson(Map<String, dynamic> json) {
    return STRProductConfig();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class STRShareConfig {
  final String? shareUrl;
  final String? facebookAppId;
  final bool? appLogoVisibility;

  STRShareConfig({
    this.shareUrl,
    this.facebookAppId,
    this.appLogoVisibility,
  });

  factory STRShareConfig.fromJson(Map<String, dynamic> json) {
    return STRShareConfig(
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

class STRNetworkConfig {
  final String? cdnHost;
  final String? productHost;
  final String? analyticHost;
  final String? placementHost;

  STRNetworkConfig({
    this.cdnHost,
    this.productHost,
    this.analyticHost,
    this.placementHost,
  });

  factory STRNetworkConfig.fromJson(Map<String, dynamic> json) {
    return STRNetworkConfig(
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
