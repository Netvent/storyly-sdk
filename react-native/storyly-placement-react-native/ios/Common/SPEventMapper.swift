//
//  SPEventMapper.swift
//  Pods
//
//  Created by Haldun Melih Fadillioglu on 16.12.2025.
//


@objc public class SPEventMapper: NSObject {
  @objc public class func mapProviderEvent(_ event: SPPlacementProviderEventType) -> String {
    return event.eventName
  }
  
  @objc public class func mapPlacementEvent(_ event: SPPlacementEventType) -> String {
    return event.eventName
  }
  
  @objc public class func allPlacementEvents() -> [String] {
    return SPPlacementEventType.allCases.map { $0.eventName }
  }
  
  @objc public class func allProviderEvents() -> [String] {
    return SPPlacementProviderEventType.allCases.map { $0.eventName }
  }
}
