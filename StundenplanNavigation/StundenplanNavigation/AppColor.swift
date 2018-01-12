//
//  AppColor.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 17.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

var appColor = AppColor(faculty: Faculty.default)

struct AppColor {
    var  faculty: Faculty {
        didSet {
            // Delay, weil das SegmentedControll gedrückt wird und bei der Veränderung der Farbe, die Notification gesendet wird
            // und noch während der Touch-Animation die Farbe ändern will --> Boom! Programm Crash!
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                DispatchQueue.main.async {
                    let nc = NotificationCenter.default
                    nc.post(name: NSNotification.Name.appColorHasChanged, object: nil)
                }
            })
        }
    }
    
    init(faculty: Faculty) {
        self.faculty = faculty
    }
    
    var text: UIColor {
        return UIColor.black
    }
    
    var text2: UIColor {
        return UIColor.black.withAlphaComponent(0.2)
    }
    
    var tintColor: UIColor {
        return faculty.color
    }
    
    var delete: UIColor {
        return UIColor.red
    }
    
    var badge: UIColor {
        return tintColor
    }
    
    var headerBackground: UIColor {
        return tintColor
    }
    
    var headerText: UIColor {
        return UIColor.white
    }
    
    var taskWarning: UIColor {
        return UIColor.red
    }
    
    var currentPageIndicatorTint: UIColor {
        return tintColor.withAlphaComponent(0.3)
    }
    
    var pageIndicatorTintColor: UIColor {
        return tintColor
    }
    
    var navigationBarTintColor: UIColor {
        return UIColor.white
    }
    
}

enum Faculty {
    case economics
    case computerScience
    case engineeringSciences
    case `default`
    
    var color: UIColor {
        switch self {
        case .economics: return UIColor(red: 239.0/255.0, green: 78.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        case .computerScience: return UIColor(red: 248.0/255.0, green: 177.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        case .engineeringSciences: return UIColor(red: 51.0/255.0, green: 108.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        case .default: return UIColor(red: 75.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        }
    }
    
    var faculty : String {
        switch self {
        case .economics: return "economics"
        case .computerScience: return "computerScience"
        case .engineeringSciences: return "engineeringSciences"
        case .default: return "default"
        }
    }
}
