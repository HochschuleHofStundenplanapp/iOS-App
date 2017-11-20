//
//  myObserverProtocol.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf & Kevin Rodd on 30.03.17.
//  Copyright © 2017 Andreas Wolf. All rights reserved.
//

import Foundation

/// Lässt eine KLasse zu einem Beobachter werden
protocol myObserverProtocol : NSObjectProtocol  {
    
    func update (s:String?) -> Void
    
}
