//
//  ActivityIndicator.swift
//  StundenplanNavigation
//
//  Created by Peter Stoehr on 30.06.17.
//  Copyright © 2017 Peter Stoehr. All rights reserved.
//

import UIKit

class ActivityIndicator: NSObject {
    
    var activityIndicator:UIActivityIndicatorView!
    
    func startActivityIndicator(root:UIViewController)
    {
        
        activityIndicator = UIActivityIndicatorView(frame:root.view.frame) as UIActivityIndicatorView

        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = root.view.center
        activityIndicator.backgroundColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.25)
        
        root.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator()-> Void
    {
        activityIndicator.removeFromSuperview()
    }
    
    
}
