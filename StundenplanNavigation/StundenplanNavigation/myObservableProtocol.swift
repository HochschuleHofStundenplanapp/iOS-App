//
//  myObservableProctocol.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf & Kevin Rodd on 30.03.17.
//  Copyright © 2017 Andreas Wolf. All rights reserved.
//

import Foundation


/// Lässt eine Klasse zu einem beobachtetem Objekt werden
protocol myObservable : Equatable{
    
    func addNewObserver (o: myObserverProtocol) -> Void
    func removeOldObserver (o: myObserverProtocol) -> Void
    func notifiyAllObservers(s: String?) -> Void
    
}

