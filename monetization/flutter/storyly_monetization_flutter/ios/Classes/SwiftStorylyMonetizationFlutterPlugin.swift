//
//  SwiftStorylyMonetizationFlutterPlugin.swift
//  storyly_monetization_flutter
//
//  Created by Haldun Melih Fadillioglu on 12.10.2022.
//

import Flutter
import UIKit

public class SwiftStorylyMonetizationFlutterPlugin: NSObject, FlutterPlugin {
    
    private static var storylyMonetizationFlutter: StorylyMonetizationFlutter? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "com.appsamurai.storyly.storyly_monetization_flutter/storyly_monetization_flutter", binaryMessenger: registrar.messenger())
        storylyMonetizationFlutter = StorylyMonetizationFlutter(methodChannel: methodChannel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}

