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
    
    init(lectures: [[Lecture]], selLectures : [Lecture]) {
        self.list = lectures
    }
    
    //Alle selektierten Volrlesungen werden in eine Liste gespeichert
    func extractSelectedLectures(){
        selLectures = []
        for day in list {
            for lecture in day{
                if (lecture.selected){
                    selLectures.append(lecture)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        list = aDecoder.decodeObject(forKey: "scheduleList") as! [[Lecture]]
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encode(list, forKey:"scheduleList")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Schedule(lectures: list, selLectures : selLectures)
        return copy
    }
    
    func toggleLectureAt(section: Int, row: Int){
        if(list[section][row].selected){
            list[section][row].selected = false
        }else{
            list[section][row].selected = true
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
    
    // Liefert alles Lectures zurück die hinzugefügt wurden
    func addedLectures(schedule : Schedule) -> [Lecture] {
        var addedArray = [Lecture]()
        
        for lecutre in schedule.selLectures{
            if(!selLectures.contains(lecutre)){
                addedArray.append(lecutre)
            }
        }
        
        return addedArray
        
    }
    
    // Liefert alles Lecutrues zurück die gelöscht wurden
    func removedLectures(schedule : Schedule) -> [Lecture] {
        var removedArray = [Lecture]()
        
        for lecutre in selLectures{
            if(!schedule.selLectures.contains(lecutre)){
                removedArray.append(lecutre)
            }
        }
        dump(selLectures)
        dump(schedule.selLectures)
        return removedArray
    }
    
    
}
