Pod::Spec.new do |s|
  s.name             = "SnowplowIgluClient"
  s.version          = "0.1.1"
  s.summary          = "Snowplow Iglu Client for iOS 7+ and OSX 10.9+"
  s.description      = <<-DESC
  Objective-C client for Iglu, a schema repository.
                       DESC
  s.homepage         = "http://snowplowanalytics.com"
  s.screenshots      = "https://d3i6fms1cm1j0i.cloudfront.net/github-wiki/images/snowplow-logo-large.png"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "Snowplow Analytics Ltd" => "support@snowplowanalytics.com" }
  s.source           = { :git => "https://github.com/snowplow/iglu-objc-client.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/SnowPlowData'
  s.documentation_url	= 'https://github.com/snowplow/snowplow/wiki/iglu-objc-client'

  s.requires_arc = true
  s.frameworks = 'Foundation'
  #s.ios.deployment_target = '10.0'
  #s.osx.deployment_target = '10.11'
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true
  s.frameworks = 'Foundation'
  s.dependency 'VVJSONSchemaValidation', '~> 1.5.0'
  s.frameworks = 'VVJSONSchemaValidation'

  s.source_files = 'SnowplowIgluClient/*.{m,h}', 'SnowplowIgluClient/CocoapodsHeaders/SchemaValidator.h'
  s.private_header_files = [
    'SnowplowIgluClient/CocoapodsHeaders/SchemaValidator.h',
    'SnowplowIgluClient/IGLUResolver.h',
    'SnowplowIgluClient/IGLUSchema.h',
  ]
  s.public_header_files = [
    'SnowplowIgluClient/IGLUConstants.h',
    'SnowplowIgluClient/IGLUClient.h',
    'SnowplowIgluClient/IGLUUtilities.h'
  ]

  s.resource_bundles = { 'SnowplowIgluResources' => ['SnowplowIgluResources/IGLUResources/**'] }
end
