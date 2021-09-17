#
#  Be sure to run `pod spec lint LYUIExposureManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "LYUIExposureManager"
  s.version      = "1.0.7"
  s.summary      = "监听普通 view 曝光的封装处理"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                     监听普通 view 曝光的封装处理 ^-^
                   DESC

  s.homepage     = "https://github.com/Liya86/LYUIExposureManager"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = "Liya86"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Liya86/LYUIExposureManager.git", :tag => "1.0.7" }
  s.source_files = "Source/**/*.{h,m}"
  s.frameworks   = "Foundation", "UIKit"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
