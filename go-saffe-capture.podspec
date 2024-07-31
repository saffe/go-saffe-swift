Pod::Spec.new do |s|
  s.name         = 'GoSaffeCapture'
  s.version      = '1.0.0'
  s.summary      = 'A Swift framework for creating a GoSaffeCapture instance'
  s.description  = 'This framework provides a way to create a GoSaffeCapture instance and load the liveness page.'
  s.homepage     = 'https://github.com/saffe/go-saffe-swift'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Pedro Cruz' => 'pedro@saffe.ai' }
  s.source       = { :git => 'https://github.com/saffe/go-saffe-swift.git', :tag => s.version }
  s.source_files = 'go-saffe-swift/**/*.{swift}'
  s.frameworks   = 'WebKit'
end
