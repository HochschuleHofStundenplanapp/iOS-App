//
//  CalendarEventIds.swift
//  StundenplanNavigation
//
//  Created by Daniel on 27.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

public class CalendarData: NSObject, NSCoding {
    public static var sharedInstance = CalendarData()
    
    public var lecturesEventIdDictonary : [String:[String]] = [:]
    public var changesEventIdDictonary : [String:[String]] = [:]
    public let lecturesEventIdDictonaryKey = "lecturesEventIdDictonary"
    public let changesEventIdDictonaryKey = "changesEventIdDictonary"
    
    private override init () {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        lecturesEventIdDictonary = aDecoder.decodeObject(forKey: lecturesEventIdDictonaryKey) as! Dictionary
        changesEventIdDictonary = aDecoder.decodeObject(forKey: changesEventIdDictonaryKey) as! Dictionary
        super.init()
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(lecturesEventIdDictonary, forKey: lecturesEventIdDictonaryKey)
        aCoder.encode(changesEventIdDictonary, forKey: changesEventIdDictonaryKey)
    }
}
