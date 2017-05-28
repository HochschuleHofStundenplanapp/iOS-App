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
        
    func add(lecture: Lecture, at day: Int){
        allLectures[day].append(lecture)
    }
    
    func clear(){
        allLectures = [[],[],[],[],[],[]]
    }
    
    func daySize(at section: Int) -> Int{
        return allLectures[section].count
    }
    
    func lecture(at indexPath: IndexPath) -> Lecture{
        return allLectures[indexPath.section][indexPath.row]
    }
    
    func removeLecture(at indexpath: IndexPath){
        allLectures[indexpath.section].remove(at: indexpath.row)
    }
}
