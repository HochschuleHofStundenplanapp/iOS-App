//
//  Schedule.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Studenplan
class Schedule : NSObject, NSCopying, NSCoding{
    var list : [[Lecture]] = [[],[],[],[],[],[]]
    var selLectures : [Lecture] = []
    
    let listKey = "scheduleList"
    let selLecturesKey = "selLectures"
    
    override init() {}
    
    init(lectures: [[Lecture]], selLectures : [Lecture]) {
        self.list = []
        self.selLectures = []
        
        for day in lectures{
            var tmp = [Lecture]()
            for lecture in day{
                tmp.append(lecture.copy() as! Lecture)
            }
            self.list.append(tmp)
        }
        
        for lecture in selLectures{
            self.selLectures.append(lecture.copy() as! Lecture)
        }
    }
    
    func deselectUnusedLectures(){
        for item in list{
            setSelectionLectures(lecturesArray: item)
        }
    }
    
    private func setSelectionLectures(lecturesArray: [Lecture]) {
        
        var tupels : [(Course, Semester)] = []
        
        var selectedCourses = Settings.sharedInstance.tmpCourses.selectedCourses();
        
        for item in selectedCourses{
            
            var selectedSem = item.semesters.selectedSemesters()
            
            for semItem in selectedSem{
                tupels.append((item, semItem))
            }
        }
        
        for lec in lecturesArray{
            var tmpTupel = (lec.course, lec.semester)
            
            if (lec.selected){
                lec.selected = hasTupel(arr: tupels, tupel: tmpTupel)
            }
            
        }
                
    }
    
    func hasTupel(arr: [(Course, Semester)], tupel: (Course, Semester)) -> Bool{
        
        for item in arr{
            if(item.0.contraction == tupel.0.contraction && item.1.name == tupel.1.name){
                return true
            }
        }
        return false
    }
    
    func hasCourse(course: Course) -> Bool{
        
        var foundItem = false;
        
        for item in selLectures{
            if(item.course.contraction == course.contraction){
                foundItem = true
            }
        }
        
        return foundItem
    }
    
//    func fundCourse(course: Course) -> Lecture{
//        
//        for item in selLectures{
//            if (item.course.contraction == course.contraction){
//                return item
//            }
//        }
//        
//        return
//    }
    
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
        list = aDecoder.decodeObject(forKey: listKey) as! [[Lecture]]
        selLectures = aDecoder.decodeObject(forKey: selLecturesKey) as! [Lecture]
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(list, forKey: listKey)
        aCoder.encode(selLectures, forKey: selLecturesKey)
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
    
    func isAllSelected()->Bool{
        for i in list{
            for j in i{
                if(!j.selected){
                    return false
                }
            }
        }
        return true
    }
    
    func setSelection(){
        for day in list {
            for newLecture in day{
                for oldLecture in selLectures{
                    if(oldLecture == newLecture){
                        newLecture.selected = oldLecture.selected
                        newLecture.eventIDs = oldLecture.eventIDs
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
            if lectures[index].count > 1
            {
                lectures[index].sort{$0.starttime < $1.starttime}
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
        
        setSelection()
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
    
    // Liefert alles Lectures zurück die entfernt wurde
    func removedLectures(oldSchedule : Schedule) -> [Lecture] {
        var removedArray = [Lecture]()
        
        for lecture in oldSchedule.selLectures{
            var contains = false
            
            for newLecture in selLectures {
                if newLecture.hashValue == lecture.hashValue {
                    contains = true
                }
            }
            if(!contains){
                removedArray.append(lecture)
            }
        }
        return removedArray
    }
    
    // Liefert alles Lecutrues zurück die gelöscht wurden
    func addedLectures(oldSchedule : Schedule) -> [Lecture] {
        
        var addedArray = [Lecture]()
        
        for newLecture in selLectures{
            var contains = false
            
            for oldLecture in oldSchedule.selLectures {
                if oldLecture.hashValue == newLecture.hashValue {
                    contains = true
                }
            }
            if(!contains){
                addedArray.append(newLecture)
            }
        }
        
        return addedArray
   }
    
}
