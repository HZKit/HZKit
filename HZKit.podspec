Pod::Spec.new do |s|

  s.name         = "HZKit"
  s.version      = "0.1.4.3"
  s.summary      = "Universal code package for rapid development."
  s.homepage     = "https://github.com/HZKit/HZKit"
  s.license      = "MIT"
  s.author             = { "Hertz Wang" => "hertz@hertzwang.com" }
  s.social_media_url   = "https://github.com/HZKit/HZKit"
  s.platform     = :ios, "8.0"
  s.source = { :git => "https://github.com/HZKit/HZKit.git", :tag => s.version }

  s.requires_arc = true
  s.source_files  = "Source/**/*.{h,m}"
  s.public_header_files = "Source/**/*.{h}"
  
  s.subspec 'Authorization' do |auth|
    auth.source_files = 'Source/Authorization/*.{h,m}'
    auth.public_header_files = 'Source/Authorization/HZKitAuthorization.h'
  end
  
  s.subspec 'Device' do |device|
    device.source_files = 'Source/Device/*.{h,m}'
    device.public_header_files = 'Source/Device/HZKitDevice.h'
  end

end
