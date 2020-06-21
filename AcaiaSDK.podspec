Pod::Spec.new do |s|
  s.name = "AcaiaSDK"
  s.version = "1.0.1"
  s.platform = :ios, '10.0'
  s.summary = "Acaia SDK to work with Acaia Pearl and Lunar."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.author = "Acaia Corp"
  s.homepage = "https://github.com/acaia/acaia_sdk_ios"
  s.description = "This is the SDK for iOS developer to connect with Acaia Perl and Lunar scales."
  s.source = { :git => 'https://github.com/acaia/acaia_sdk_ios.git', :tag => s.version.to_s }
  s.ios.deployment_target    = '10.0'
  s.ios.vendored_framework   = 'AcaiaSDK.framework'
end
