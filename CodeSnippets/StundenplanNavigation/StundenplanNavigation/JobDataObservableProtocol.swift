//
//  JobDataObservableProtocol.swift
//  StundenplanNavigation
//
//  Created by Kevin Rodd on 10.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation


/// Lässt eine Klasse zu einem beobachtetem Objekt werden
protocol JobDataObservableProtocol : Equatable{
    
    func addNewObserver (o: JobDataObserverProtocol) -> Void
    func removeOldObserver (o: JobDataObserverProtocol) -> Void
    func notifiyAllObservers(o: AnyObject, p : Int) -> Void
    
}
