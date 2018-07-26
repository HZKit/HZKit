Pod::Spec.new do |s|

  s.name         = "HZKit"
  s.version      = "0.1.3"
  s.summary      = "Universal code package for rapid development."
  s.homepage     = "https://github.com/HZKit/HZKit"
  s.license      = "MIT"
  s.author             = { "Hertz Wang" => "hertz@hertzwang.com" }
  s.social_media_url   = "https://github.com/HZKit/HZKit"
  s.platform     = :ios, "8.0"
  s.source = { :git => "https://github.com/HZKit/HZKit.git", :tag => s.version }
  s.source_files  = "Source/*.{h,m}"

end
