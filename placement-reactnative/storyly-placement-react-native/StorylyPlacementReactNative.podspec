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
    s.source_files = "ios/Common/**/*.{h,m,mm,swift}", "ios/NewArch/**/*.{h,mm,swift}"
    s.private_header_files = "ios/NewArch/**/*.h"
  else
    s.source_files = "ios/Common/**/*.{h,m,mm,swift}", "ios/OldArch/**/*.{h,m,swift}"
    s.private_header_files = "ios/OldArch/**/*.h"
  end

  # Swift module support
  s.swift_version = "5.0"
  s.pod_target_xcconfig = {
    "DEFINES_MODULE" => "YES"
  }

  # React Native dependencies
  install_modules_dependencies(s)

  s.dependency "StorylyPlacement", "~> 1.1.0"
end
