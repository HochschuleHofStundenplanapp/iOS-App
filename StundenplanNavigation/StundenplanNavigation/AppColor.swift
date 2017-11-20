//
//  AppColor.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 17.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

var appColor = AppColor(faculty: AppColor.Faculty.computerScience)

struct AppColor {
    var faculty: Faculty
    
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
            case .default: return UIColor.black
            }
        }
    }
}
