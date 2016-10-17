Pod::Spec.new do |s|
s.name         = "KYMenu"
s.summary      = "KYmenu is the iOS application in the use of highly customized UI vertical pop-up menu."
s.version      = '0.0.3'
s.homepage     = "https://github.com/kingly09/KYMenu"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "kingly" => "libintm@163.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/kingly09/KYMenu.git", :tag => s.version.to_s }
s.social_media_url   = "https://github.com/kingly09"
s.source_files = 'KYMenu/*.{h,m}'
s.framework    = "UIKit"
s.requires_arc = true
end
