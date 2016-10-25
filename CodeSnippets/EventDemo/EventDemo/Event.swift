//
//  Event.swift
//  EventDemo
//
//  Created by Daniel on 25.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import Foundation

class Event {
    var eventID : String?
    var title: String
    var startDate: Date
    var endDate: Date
    var location: String
    var description: String
    
    init(title: String, startDate: Date, endDate: Date, location: String, description: String, eventID: String?) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.description = description
        self.eventID = eventID
    }
}
