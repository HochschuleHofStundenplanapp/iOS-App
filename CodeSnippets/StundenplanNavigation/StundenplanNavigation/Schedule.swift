//
//  Schedule.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 11.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class Schedule: NSObject {

    var allLectures: [[Lecture]] = [[],[],[],[],[],[]]
        
    func addSchedule(lectures: [Lecture]){
        for lec in lectures{
            let dayIndex = Constants.weekDays.index(of: lec.day)!
            
            allLectures[dayIndex].append(lec)
        }
    }
    
    func daySize(at section: Int) -> Int{
        return allLectures[section].count
    }
    
    func lecture(at indexPath: IndexPath) -> Lecture{
        return allLectures[indexPath.section][indexPath.row]
    }
}
