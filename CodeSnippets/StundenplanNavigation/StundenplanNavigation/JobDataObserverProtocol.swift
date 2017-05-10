//
//  JobDataObserverProtocol.swift
//  StundenplanNavigation
//
//  Created by Kevin Rodd on 10.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

/// Lässt eine KLasse zu einem Beobachter werden
protocol JobDataObserverProtocol : NSObjectProtocol  {
    
    func update (o:AnyObject, p: Int) -> Void
    
}
