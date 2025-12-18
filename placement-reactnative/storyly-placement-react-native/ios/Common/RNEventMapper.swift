//
//  RNEventMapper.swift
//  Pods
//
//  Created by Haldun Melih Fadillioglu on 16.12.2025.
//


@objc public class RNEventMapper: NSObject {
  @objc public class func mapProviderEvent(_ event: RNPlacementProviderEventType) -> String {
    return event.eventName
  }
  
  @objc public class func mapPlacementEvent(_ event: RNPlacementEventType) -> String {
    return event.eventName
  }
  
  @objc public class func allPlacementEvents() -> [String] {
    return RNPlacementEventType.allCases.map { $0.eventName }
  }
  
  @objc public class func allProviderEvents() -> [String] {
    return RNPlacementProviderEventType.allCases.map { $0.eventName }
  }
}
