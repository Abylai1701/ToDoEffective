# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'ToDo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ToDo
  pod 'SnapKit'
  pod 'IQKeyboardManager'
  pod 'Alamofire', '~> 5.4'

 post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end

end
