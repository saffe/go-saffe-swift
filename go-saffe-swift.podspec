#
# Be sure to run `pod lib lint go-saffe-swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'go-saffe-swift'
  s.version          = '1.0.0'
  s.summary          = 'Go saffe capture component for swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Go saffe capture component for swift
                       DESC

  s.homepage         = 'https://github.com/saffe/go-saffe-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pedro Cruz' => 'pedrovictor.lage@gmail.com' }
  s.source           = { :git => 'https://github.com/saffe/go-saffe-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'go-saffe-swift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'go-saffe-swift' => ['go-saffe-swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
