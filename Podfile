# This podfile is intended for development and testing on Snowplow.
#
# If you are working on Snowplow, you do not need to have CocoaPods installed
# unless you want to install new development dependencies as the Pods directory
# is part of the source tree.

source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'SnowplowIgluClient.xcodeproj'

target 'SnowplowIgluClient' do
  inherit! :search_paths
  platform :osx, '10.9'
  pod 'KiteJSONValidator', '~> 0.2.3'
end

target 'SnowplowIgluClientTests' do
  inherit! :search_paths
  platform :osx, '10.9'
  pod 'KiteJSONValidator', '~> 0.2.3'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
