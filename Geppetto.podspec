Pod::Spec.new do |s|
  s.name         = "Geppetto"
  s.version      = "0.2.3"
  s.summary      = "Declaritive Reactive Functional Architecture for iOS Application"
  s.homepage     = "https://github.com/rinndash/Geppetto"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Jinseo Yoon" => "rinndash@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/rinndash/Geppetto.git", :tag => s.version.to_s }
  s.source_files  = "Sources", "Sources/**/*.{h,m,swift}"
  
  s.swift_version = '5.0'
  s.framework  = "Foundation", "UIKit"
  
  s.dependency "RxSwift", '~> 5'
  s.dependency "RxCocoa", '~> 5'
  s.dependency "RxSwiftExt", '~> 5'
end
