//
//  PopUpMenueDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 17.01.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class PopUpMenueDelegate: NSObject, UIPopoverPresentationControllerDelegate {
    
    // Überschreibt das Verhalten, dass popover beim iPhone als Fullscreen dargestellt werden.
    // Popover für iPhone und iPad sehen nun identisch aus
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
