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
    var selLectures : [Lecture] = []
    
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
//            let index = selLectures.index(of: list[section][row])
//            selLectures.remove(at: index!)
        }else{
            list[section][row].selected = true
//            selLectures.append(list[section][row])
        }
    }
    
    func mergeLectures(){
        for day in list {
            for newLecture in day{
                for oldLecture in selLectures{
                    if(oldLecture == newLecture){
                        newLecture.selected = oldLecture.selected
                    }
                }
            }
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
        
        mergeLectures()
        
//        dump(list)
    }
    
    func getLectureAt(section: Int, row: Int) -> Lecture{
        return list[section][row]
    }
    
    func clearSchedule(){
        list = [[],[],[],[],[],[]]
        selLectures = []
    }
    
    func sizeAt(section: Int) -> Int{
        return list[section].count
    }
    
    // Liefert alles Lectures zurück die hinzugefügt wurden
    func addedLectures(schedule : Schedule) -> [Lecture] {
        var addedArray = [Lecture]()
        
        for i in 0..<6{
            for lecutre in schedule.list[i]{
                if(!list[i].contains(lecutre)){
                    addedArray.append(lecutre)
                }
            }
        }

        return addedArray
    }
    
    // Liefert alles Lecutrues zurück die gelöscht wurden
    func removedLectures(schedule : Schedule) -> [Lecture] {
        var removedArray = [Lecture]()
        
        for i in 0..<6{
            for lecutre in list[i]{
                if(!schedule.list[i].contains(lecutre)){
                    removedArray.append(lecutre)
                }
            }
        }
        
        return removedArray
    }

    
}
