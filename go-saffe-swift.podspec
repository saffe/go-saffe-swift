Pod::Spec.new do |s|
  s.name             = 'go-saffe-swift'
  s.version          = '1.2.0'
  s.summary          = 'Go saffe capture component for swift'
  s.description      = <<-DESC
  Go saffe capture component for swift
                       DESC
  s.homepage         = 'https://github.com/saffe/go-saffe-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pedro Cruz' => 'pedro@saffe.ai' }
  s.source           = { :git => 'https://github.com/saffe/go-saffe-swift.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.source_files  = "go-saffe-swift/**/*.{swift,h,m}"
  s.frameworks = "UIKit", "WebKit"
end
