//
//  Schedule.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Studenplan
class Schedule {
    
    static let sharedInstance = Schedule()
    
    private init(){}
    
    //Winter oder Sommersemester
    var courses : Courses = Courses()//Studiengänge
    var schedule : [Lecture] = []
    
}
