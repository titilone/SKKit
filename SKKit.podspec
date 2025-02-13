Pod::Spec.new do |s|
  s.name             = 'SKKit'
  s.version          = '0.0.1'

  s.summary          = 'SKKit summary'
  s.description      = 'SKKit description'
  s.homepage         = 'https://github.com/titilone/SKKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'titilone' => 'huijian0gao@126.com' }
  s.source           = { :git => 'https://github.com/titilone/SKKit.git', :tag => s.version }
  s.source_files = 'SKKit/**/*'
  #s.platform = :ios, '12.0'
  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.0', '5.1', '5.2']
  s.dependency 'MBProgressHUD', '~> 1.2.0'
  s.dependency 'Alamofire', '~> 5.10.2'
end
