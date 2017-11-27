//
//  UIView.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 27.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func applyShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
    }
}
