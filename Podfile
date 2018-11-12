source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
workspace 'puffer'
inhibit_all_warnings!

target :Segment do
    pod 'SnapKit', '~> 4.0.1'
    project 'segment.xcodeproj'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
