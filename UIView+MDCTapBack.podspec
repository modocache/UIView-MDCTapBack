Pod::Spec.new do |s|
  s.name         = 'UIView+MDCTapBack'
  s.version      = '0.1.0'
  s.summary      = 'Record taps and execute tap callbacks on any instance of UIView.'
  s.homepage     = 'https://github.com/modocache/UIView-MDCTapBack'
  s.license      = 'MIT'
  s.author       = { 'modocache' => 'modocache@gmail.com' }
  s.source       = { :git => 'https://github.com/modocache/UIView-MDCTapBack.git', :tag => "v#{s.version}" }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.platform     = :ios, '5.0'
  s.framework    = 'UIKit'
end

