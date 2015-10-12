# This podfile is intended for development and testing on Snowplow.
#
# If you are working on Snowplow, you do not need to have CocoaPods installed
# unless you want to install new development dependencies as the Pods directory
# is part of the source tree.

source 'https://github.com/CocoaPods/Specs.git'

platform :osx, '10.9'
xcodeproj 'SnowplowIgluClient.xcodeproj'
pod 'KiteJSONValidator', '~> 0.2.3'

post_install do |installer|
  if Gem::Version.new(Gem.loaded_specs['cocoapods'].version) >= Gem::Version.new('0.38.0')
    install_38 installer
  else
    install_37 installer
  end
end

def install_38 installer
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end

def install_37 installer
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
