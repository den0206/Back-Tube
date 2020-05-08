//
//  AdMobHelper .swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/05/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import GoogleMobileAds

class AdMobHelper : NSObject {
    
    static let shared = AdMobHelper()
    
    func initSDK() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
   
    func setupBannerAd(adBaseView: UIView, rootVC: UIViewController,bannerId : String) {
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        #if DEBUG
        adView.adUnitID = bannerId
        #else
        if rootVC is ViewController {
            adView.adUnitID = bannerId
        } else if rootVC is ViewController2 {
            adView.adUnitID = bannerId
        }
        #endif
        adView.rootViewController = rootVC
        adView.load(GADRequest())
        adBaseView.addSubview(adView)
//        adView.translatesAutoresizingMaskIntoConstraints = false
//        adView.centerXAnchor.constraint(equalTo: adBaseView.centerXAnchor).isActive = true
//        adView.centerYAnchor.constraint(equalTo: adBaseView.centerYAnchor).isActive = true
//        adView.widthAnchor.constraint(equalToConstant: 320.0).isActive = true
//        adView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    func mediumBannerAd(adBaseView: UIView, rootVC: UIViewController,bannerId : String) {
        let adView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        #if DEBUG
        adView.adUnitID = bannerId
        #else
        if rootVC is ViewController {
            adView.adUnitID = bannerId
        } else if rootVC is ViewController2 {
            adView.adUnitID = bannerId
        }
        #endif
        adView.rootViewController = rootVC
        adView.load(GADRequest())
        adBaseView.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.centerXAnchor.constraint(equalTo: adBaseView.centerXAnchor).isActive = true
        adView.anchor(top: adBaseView.topAnchor)
        adView.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        //        adView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
}
