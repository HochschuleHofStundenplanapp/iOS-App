//
//  Schedule.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 11.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class Schedule: NSObject {

    var lectures: [[Lecture]]
    
    override init() {
        lectures = [[],[],[],[],[],[]]
    }
    
    init(lectures: [[Lecture]]){
        self.lectures = lectures
    }
    
    func add(lecture: Lecture, at day: Int){
        lectures[day].append(lecture)
    }
    
    func clear(){
        lectures = [[],[],[],[],[],[]]
    }
    
    func daySize(at section: Int) -> Int{
        return lectures[section].count
    }
    
    func lecture(at indexPath: IndexPath) -> Lecture{
        return lectures[indexPath.section][indexPath.row]
    }
    
    func removeLecture(at indexpath: IndexPath){
        lectures[indexpath.section].remove(at: indexpath.row)
    }
    
    override func copy() -> Any {
        let copy = Schedule(lectures: lectures)
        return copy
    }
    
    func contains(lecture: Lecture) -> Bool{
                
        for day in lectures{
            for lec in day{
                if lec == lecture{
                    return true
                }
            }
        }
        
        return false
    }
    
    func getOneDimensionalList() -> [Lecture]{        
        var newList : [Lecture] = [Lecture]()
        
        for day in lectures{
            for lecture in day{
                newList.append(lecture)
            }
        }
        return newList
    }
}
