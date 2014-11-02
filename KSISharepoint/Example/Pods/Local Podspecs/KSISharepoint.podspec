#
# Be sure to run `pod lib lint KSISharepoint.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KSISharepoint"
  s.version          = "0.1.0"
  s.summary          = "Library for working with Sharepoint."
  s.description      = <<-DESC
                        This library allows to work with Sharepoint.

Currently supported Sharepoint versions:
* Office 365
                        DESC
  s.homepage         = "https://github.com/santifdezmunoz/KSISharepoint"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Santi Fdez Muñoz" => "loopieback@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/KSISharepoint.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/santifdezmunoz'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'KSISharepoint' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Mantle', '~> 1.5'

end
