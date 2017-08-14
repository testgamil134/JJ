source 'https://github.com/CocoaPods/Specs.git'
platform:ios, '10.0'
use_frameworks!

target 'JJ' do
  pod 'Alamofire', '= 4.4'
  pod 'Kingfisher', '= 3.10.3'
	pod 'SnapKit', '= 3.2.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
