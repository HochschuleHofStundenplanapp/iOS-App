//
//  CalendarEventIds.swift
//  StundenplanNavigation
//
//  Created by Daniel on 27.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

class CalendarData: NSObject, NSCoding {
    public static var sharedInstance = CalendarData()
    
    var lecturesEventIdDictonary : [String:[String]] = [:]
    var changesEventIdDictonary : [String:[String]] = [:]
    let lecturesEventIdDictonaryKey = "lecturesEventIdDictonary"
    let changesEventIdDictonaryKey = "changesEventIdDictonary"
    
    private override init () {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        lecturesEventIdDictonary = aDecoder.decodeObject(forKey: lecturesEventIdDictonaryKey) as! Dictionary
        changesEventIdDictonary = aDecoder.decodeObject(forKey: changesEventIdDictonaryKey) as! Dictionary
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(lecturesEventIdDictonary, forKey: lecturesEventIdDictonaryKey)
        aCoder.encode(changesEventIdDictonary, forKey: changesEventIdDictonaryKey)
    }
}
