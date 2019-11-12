# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def system_pods
  pod 'SVProgressHUD'
  pod 'SystemServices', '~> 2.0.1'
  pod 'Charts'
  pod 'iRate'
end

def today_pods
  pod 'Charts'
  pod 'SystemServices', '~> 2.0.1'
end

target 'System' do
  use_frameworks!
  
  system_pods
end

target 'TodayExtension' do
  use_frameworks!
  
  today_pods
end
