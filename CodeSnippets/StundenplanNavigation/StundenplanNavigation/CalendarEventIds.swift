//
//  CalendarEventIds.swift
//  StundenplanNavigation
//
//  Created by Daniel on 27.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

class CalendarEventIds: NSObject, NSCoding {
    static var sharedInstance = CalendarEventIds()
    
    var eventIdDictonary : [Int:[String]] = [:]
    let eventIdDictonaryKey = "eventIdDictonary"
    
    private override init () {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        eventIdDictonary = aDecoder.decodeObject(forKey: eventIdDictonaryKey) as! Dictionary
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(eventIdDictonary, forKey: eventIdDictonaryKey)
    }
}
