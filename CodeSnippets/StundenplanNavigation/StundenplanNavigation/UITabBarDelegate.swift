//
//  UITabBarDelegate.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 06.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class UITabBarDelegate: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = tabBarController.selectedIndex
        if(index == 2){
            Settings.sharedInstance.copyData()
            Settings.sharedInstance.tmpSchedule.extractSelectedLectures()
        }
    }
    
}
