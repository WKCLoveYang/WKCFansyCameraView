Pod::Spec.new do |s|
s.name         = "WKCFansyCameraView"
s.version      = "2.0.1"
s.summary      = "自定义相机视图"
s.homepage     = "https://github.com/WKCLoveYang/WKCFansyCameraView.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WKCLoveYang" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCFansyCameraView.git", :tag => "2.0.1" }

s.frameworks = "Foundation", "UIKit"
s.requires_arc = true
s.source_files  = "WKCFansyCameraView/**/*.{h,m,mm}"
s.public_header_files = "WKCFansyCameraView/**/*.h"
s.resources = "WKCFansyCameraView/Resource/*.png"

end
