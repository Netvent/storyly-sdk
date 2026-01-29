require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "StorylyPlacementReactNative"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/Netvent/storyly-sdk.git", :tag => "#{s.version}" }

  # Conditionally include architecture-specific files
  if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
    s.source_files = "ios/Common/**/*.{h,m,mm,swift}", "ios/NewArch/**/*.{h,mm,swift}", "ios/*.h"
    s.private_header_files = "ios/NewArch/**/*.h", "ios/*.h"
  else
    s.source_files = "ios/Common/**/*.{h,m,mm,swift}", "ios/OldArch/**/*.{h,m,swift}", "ios/*.h"
    s.private_header_files = "ios/OldArch/**/*.h", "ios/*.h"
  end

  s.requires_arc = true
  s.swift_version = "5.0"
  
  s.pod_target_xcconfig = {
    "PRODUCT_MODULE_NAME" => "StorylyPlacementReactNative",
    "DEFINES_MODULE" => "YES",
    "SWIFT_INSTALL_OBJC_HEADER" => "YES",
    "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "StorylyPlacementReactNative-Swift.h",
  }

  # React Native dependencies
  install_modules_dependencies(s)

  s.dependency "StorylyPlacement", "1.3.1"
end
