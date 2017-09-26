project 'Neodius.xcodeproj'
platform :ios, '8.0'
#use_frameworks!
target 'Neodius' do

  #Git pods
  pod "FontAwesome4-ios", :git => 'https://github.com/ITSVision/FontAwesome4-ios.git'
  pod "RFAboutView", :git => 'https://github.com/ITSVision/RFAboutView.git'
  
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
  
  post_install do |installer|
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Neodius/Pods-Neodius-acknowledgements.plist', 'Neodius/Acknowledgements.plist', :remove_destination => true)
  end

end


