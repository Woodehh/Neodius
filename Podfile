project 'Neodius.xcodeproj'
platform :ios, '8.0'
target 'Neodius' do
  inhibit_all_warnings!

  use_frameworks!

  #Git pods
  pod "FontAwesome4-ios", :git => 'https://github.com/ITSVision/FontAwesome4-ios.git'
  pod "RFAboutView", :git => 'https://github.com/ITSVision/RFAboutView.git'
  
  pod "BEMSimpleLineGraph", :path => "~/Dropbox/LocalDevelopment/BEMSimpleLineGraph"
  pod "GSLanguagePickerController", :git => "https://github.com/ITSVision/GSLanguagePickerController"
  
  #Real pods
  pod "ViewDeck"
  pod "APParallaxHeader"
  pod "AFNetworking"
  pod "MBProgressHUD"
  pod "SimpleKeychain"
  pod "UIAlertView+Blocks"
  pod "LTHPasscodeViewController"
  pod "SGNavigationProgress"
  pod "Reachability"
  pod "CWStatusBarNotification"
  pod "KLCPopup"
  pod "QrcodeBuilder"
  pod "UIWebView-Blocks"
  pod "YCFirstTime"
  pod "MSSimpleGauge"
  pod "QRCodeReaderViewController"
  pod "BDGShare"
  pod "XMLReader"
  pod "KXHtmlLabel"
  pod "Regexer"
  pod "AsyncImageView"
  pod "EXPhotoViewer"
  pod "AsyncImageView"
  pod "Fabric"
  pod "Crashlytics"
  pod "Instabug" 
  pod "DateTools"


  post_install do |installer|
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Neodius/Pods-Neodius-acknowledgements.plist', 'Neodius/Acknowledgements.plist', :remove_destination => true)
  end

end


