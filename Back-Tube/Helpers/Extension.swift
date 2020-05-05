//
//  Extension.swift
//  Back-Tube
//
//  Created by 酒井ゆうき on 2020/04/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top : NSLayoutYAxisAnchor? = nil, left : NSLayoutXAxisAnchor? = nil, bottom :NSLayoutYAxisAnchor? = nil, right : NSLayoutXAxisAnchor? = nil, paddongTop : CGFloat = 0, paddingLeft : CGFloat = 0, paddiongBottom : CGFloat = 0, paddingRight : CGFloat = 0, width : CGFloat? = nil, height : CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddongTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddiongBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    // center sec
    
    func centerX(inView view : UIView, topAnchor : NSLayoutYAxisAnchor? = nil, paddingTop : CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view : UIView, leftAnchor : NSLayoutXAxisAnchor? = nil, paddingLeft : CGFloat? = nil, constant : CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func center(inView view : UIView, yConstant : CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
 

    
    // set Dimension
    
    func setDimension(width : CGFloat, height : CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    


}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}



extension UIColor {
    
    static func rgb(red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let backGroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
}

extension URL {
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url
    }
}

extension UIViewController {
    
    func showErrorAlert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

extension UITabBarController {
    
    func showPresentLoadindView(_ present : Bool, message : String? = nil) {
            
            if present {
                
                let blackView = UIView()
                blackView.frame = self.view.bounds
                blackView.backgroundColor = .white
                blackView.alpha = 0
                blackView.tag = 1
                
                let indicator = UIActivityIndicatorView()
                indicator.color = .black
                indicator.style = .large
                indicator.center = blackView.center
                
                let label = UILabel()
                label.text = message
                label.font = UIFont.systemFont(ofSize: 16)
                label.textColor = .black
                label.textAlignment = .center
                label.alpha = 0.7
                
            
    //            self.view.bringSubviewToFront(blackView)
                self.view.addSubview(blackView)
                blackView.addSubview(indicator)
                blackView.addSubview(label)
                
                label.centerX(inView: view)
                label.anchor(top : indicator.bottomAnchor,paddongTop: 23)
                
                indicator.startAnimating()
                
                UIView.animate(withDuration: 0.2) {
                    blackView.alpha = 0.7
                }
                
                
            } else {
                
                // hide
                view.subviews.forEach { (subview) in
                    
                    if subview.tag == 1 {
                        UIView.animate(withDuration: 0.5, animations: {
                            subview.alpha = 0
                        }) { (_) in
                            subview.removeFromSuperview()
                        }
                    }
                }
                
            }
        }
    
}
