Pod::Spec.new do |s|
  s.name         = "Geppetto"
  s.version      = "0.1.0"
  s.summary      = "Declaritive Reactive Functional Architecture for iOS Application"
  s.homepage     = "https://github.com/rinndash/Geppetto"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Jinseo Yoon" => "rinndash@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/rinndash/Geppetto.git", :commit => "210b37312991ebe30d5ecc017779af030440fcb5" }
  s.source_files  = "Sources", "Sources/**/*.{h,m,swift}"
  
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
end
