import Foundation
import StorylyPlacement
import StorylyCore

func decodeSTRPlacementConfig(_ config: [String: Any], token: String) -> STRPlacementConfig {
  let builder = STRPlacementConfig.Builder()
  
  if let testMode = config["testMode"] as? Bool {
    _ = builder.setTestMode(isTest: testMode)
  }
  
  if let locale = config["locale"] as? String {
    _ = builder.setLocale(locale: locale)
  }
  
  if let layoutDirection = config["layoutDirection"] as? String {
    _ = builder.setLayoutDirection(direction: layoutDirection == "rtl" ? .RTL : .LTR)
  }
  
  if let customParameter = config["customParameter"] as? String {
    _ = builder.setCustomParameter(parameter: customParameter)
  }
  
  if let labels = config["labels"] as? [String] {
    _ = builder.setLabels(labels: Set(labels))
  }
  
  if let userProperties = config["userProperties"] as? [String: String] {
    _ = builder.setUserProperties(data: userProperties)
  }
  
  if let productConfigDict = config["productConfig"] as? [String: Any],
     let productConfig = decodeSTRProductConfig(productConfigDict) {
    _ = builder.setProductConfig(config: productConfig)
  }
  
  if let shareConfigDict = config["shareConfig"] as? [String: Any],
     let shareConfig = decodeSTRShareConfig(shareConfigDict) {
    _ = builder.setShareConfig(config: shareConfig)
  }
  
  if let networkConfigDict = config["networkConfig"] as? [String: Any],
     let networkConfig = decodeSTRNetworkConfig(networkConfigDict) {
    _ = builder.setNetworkConfig(config: networkConfig)
  }
  
  return builder.build(token: token)
}

func decodeSTRProductConfig(_ productConfig: [String: Any]) -> STRProductConfig? {
  let builder = STRProductConfig.Builder()
  return builder.build()
}

func decodeSTRShareConfig(_ shareConfig: [String: Any]) -> STRShareConfig? {
  let builder = STRShareConfig.Builder()
  
  if let facebookAppId = shareConfig["facebookAppId"] as? String {
    _ = builder.setFacebookAppID(id: facebookAppId)
  }
  
  if let shareUrl = shareConfig["shareUrl"] as? String {
    _ = builder.setShareUrl(url: shareUrl)
  }
  
  if let appLogoVisibility = shareConfig["appLogoVisibility"] as? Bool {
    _ = builder.setAppLogoVisibility(isVisible: appLogoVisibility)
  }
  
  return builder.build()
}

func decodeSTRNetworkConfig(_ networkConfig: [String: Any]) -> STRNetworkConfig? {
  let builder = STRNetworkConfig.Builder()
  
  if let cdnHost = networkConfig["cdnHost"] as? String {
    _ = builder.setCdnHost(url: cdnHost)
  }
  
  if let productHost = networkConfig["productHost"] as? String {
    _ = builder.setProductHost(url: productHost)
  }
  
  if let analyticHost = networkConfig["analyticHost"] as? String {
    _ = builder.setAnalyticHost(url: analyticHost)
  }
  
  if let placementHost = networkConfig["placementHost"] as? String {
    _ = builder.setListHost(url: placementHost)
  }
  
  return builder.build()
}

