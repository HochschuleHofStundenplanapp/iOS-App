//
//  Observer.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 29.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Observer: NSObject {

    static let shared = Observer()
    private override init(){}
    
    
    dynamic var internetConnection : Bool = true
    dynamic var activityIndicator : Bool = false

}
