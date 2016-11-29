//
//  Schedule.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Studenplan
class Schedule : NSCopying{
    var list : [[Lecture]] = [[],[],[],[],[],[]]
    
    init() {}
    
    init(lectures: [[Lecture]]) {
        self.list = lectures
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Schedule(lectures: list)
        return copy
    }
    
    func toggleLectureAt(section: Int, row: Int){
        if(list[section][row].selected){
            list[section][row].selected = false
        }else{
            list[section][row].selected = true
        }
    }
    
    //Liefert alle selektierten Vorlesungen
    func selectedLectures() -> [[Lecture]]{
        var lectures : [[Lecture]] = [[],[],[],[],[],[]]
        
        for (index, day) in list.enumerated() {
            
            for lecture in day{
                if (lecture.selected){
                    lectures[index].append(lecture)
                }
            }
            
        }
        
        return lectures
    }

    func isSelected(section: Int, row: Int) -> Bool{
        return list[section][row].selected
    }
    
    func addSchedule(lectures: [Lecture]){
        
        for lec in lectures{
            let dayIndex = Constants.weekDays.index(of: lec.day)!
            
            if !list[dayIndex].contains(lec) {
                    list[dayIndex].append(lec)
            }
        }
        
        //Merge mit Lokalen und Server Daten
        
        dump(list)
    }
    
    func getLectureAt(section: Int, row: Int) -> Lecture{
        return list[section][row]
    }
    
    func clearSchedule(){
        list = [[],[],[],[],[],[]]
    }
    
    func sizeAt(section: Int) -> Int{
        return list[section].count
    }
    
    
}
