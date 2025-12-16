import Foundation
import StorylyPlacement
import StorylyCore

func decodeSTRPlacementConfig(_ config: [String: Any], token: String) -> STRPlacementConfig {
    let builder = STRPlacementConfig.Builder()
    
    if let testMode = config["testMode"] as? Bool {
      builder.setTestMode(isTest: testMode)
    }
    
    if let locale = config["locale"] as? String {
      builder.setLocale(locale: locale)
    }
    
    if let layoutDirection = config["layoutDirection"] as? String {
      builder.setLayoutDirection(direction: layoutDirection == "rtl" ? .RTL : .LTR)
    }
    
    if let customParameter = config["customParameter"] as? String {
      builder.setCustomParameter(parameter: customParameter)
    }
    
    if let labels = config["labels"] as? [String] {
      builder.setLabels(labels: Set(labels))
    }
    
    if let userProperties = config["userProperties"] as? [String: String] {
      builder.setUserProperties(data: userProperties)
    }
    
    if let productConfigDict = config["productConfig"] as? [String: Any],
       let productConfig = decodeSTRProductConfig(productConfigDict) {
      builder.setProductConfig(config: productConfig)
    }
    
    if let shareConfigDict = config["shareConfig"] as? [String: Any],
       let shareConfig = decodeSTRShareConfig(shareConfigDict) {
      builder.setShareConfig(config: shareConfig)
    }
    
    if let networkConfigDict = config["networkConfig"] as? [String: Any],
       let networkConfig = decodeSTRNetworkConfig(networkConfigDict) {
      builder.setNetworkConfig(config: networkConfig)
    }
    
  return builder.build(token: token)
}

func decodeSTRProductConfig(_ productConfig: [String: Any]) -> STRProductConfig? {
    let builder = STRProductConfig.Builder()
    
    if let isCartEnabled = productConfig["isCartEnabled"] as? Bool {
        builder.setCartEnabled(isEnabled: isCartEnabled)
    }
    
    if let isFallbackEnabled = productConfig["isFallbackEnabled"] as? Bool {
        builder.setFallbackAvailability(isEnabled: isFallbackEnabled)
    }
    
    return builder.build()
}

func decodeSTRShareConfig(_ shareConfig: [String: Any]) -> STRShareConfig? {
    let builder = STRShareConfig.Builder()
    
    if let facebookAppId = shareConfig["facebookAppId"] as? String {
        builder.setFacebookAppID(id: facebookAppId)
    }
    
    if let shareUrl = shareConfig["shareUrl"] as? String {
        builder.setShareUrl(url: shareUrl)
    }
    
    if let appLogoVisibility = shareConfig["appLogoVisibility"] as? Bool {
        builder.setAppLogoVisibility(isVisible: appLogoVisibility)
    }
    
    return builder.build()
}

func decodeSTRNetworkConfig(_ networkConfig: [String: Any]) -> STRNetworkConfig? {
    let builder = STRNetworkConfig.Builder()
    
    if let cdnHost = networkConfig["cdnHost"] as? String {
        builder.setCdnHost(url: cdnHost)
    }
    
    if let productHost = networkConfig["productHost"] as? String {
        builder.setProductHost(url: productHost)
    }
    
    if let analyticHost = networkConfig["analyticHost"] as? String {
        builder.setAnalyticHost(url: analyticHost)
    }
    
    if let placementHost = networkConfig["placementHost"] as? String {
        builder.setListHost(url: placementHost)
    }
    
    return builder.build()
}

