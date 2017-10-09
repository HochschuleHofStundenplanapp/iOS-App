//
//  myObservableProctocol.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf & Kevin Rodd on 30.03.17.
//  Copyright © 2017 Andreas Wolf. All rights reserved.
//

import Foundation


/// Lässt eine Klasse zu einem beobachtetem Objekt werden
protocol DataObservableProtocol : Equatable{
    
    func addNewObserver (o: DataObserverProtocol) -> Void
    func removeOldObserver (o: DataObserverProtocol) -> Void
    func notifiyAllObservers(o: AnyObject) -> Void
    
}

