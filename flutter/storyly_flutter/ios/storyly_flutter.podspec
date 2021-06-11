#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint storyly_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'storyly_flutter'
  s.version          = '1.11.0'
  s.summary          = 'Storyly flutter plugin.'
  s.description      = <<-DESC
  Storyly for flutter
                       DESC
  s.homepage         = "https://dashboard.storyly.io"
  s.license          = { :file => '../LICENSE' }
  s.author           = { "AppSamurai Mobile Team" => "mobile@appsamurai.com" }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_versions = ["5.0", "5.1", "5.2", "5.3"]

  s.dependency "Storyly", "1.11.1"
end
