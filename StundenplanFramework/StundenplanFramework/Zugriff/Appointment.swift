//
//  Appointment.swift
//  StundenplanFramework
//
//  Created by Bastian Kusserow on 08.01.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import Foundation

public class Appointment: NSObject, NSCoding {
    
    private let nameKey = "nameKey"
    private let dateKey = "dateKey"
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(date, forKey: dateKey)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: nameKey) as! String
        self.date = aDecoder.decodeObject(forKey: dateKey) as! DateInterval
    }
    
    
    public var name : String
    public var date : DateInterval
    
    override public var description: String
    {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "de") as Locale
        formatter.dateFormat = "dd.MM.YYYY"
        return "Name: \(name), Date: \(formatter.string(from:date.start)) - \(formatter.string(from:date.end))"
    }
    
    public init(name : String, date : DateInterval) {
        self.name = name
        self.date = date
    }
    
    
    func setDate(_ startDate : Date, _ endDate : Date){
        self.date = DateInterval(start: startDate, end: endDate)
    }
    
}

public class Tuple: NSObject,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(header, forKey: headerKey)
        aCoder.encode(appointments, forKey: appointmentsKey)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        header = aDecoder.decodeObject(forKey: headerKey) as! String
        appointments = aDecoder.decodeObject(forKey: appointmentsKey) as! [Appointment]
    }
    let headerKey = "headerKey"
    let appointmentsKey = "appointmentsKey"
    public var header : String
    public var appointments = [Appointment]()
    
    public init(name:String, appointments:[Appointment]){
        self.header = name
        self.appointments = appointments
    }
}
