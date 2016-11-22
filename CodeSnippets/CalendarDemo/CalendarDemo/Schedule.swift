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
    var list : [[Lecture]] = [[],[],[],[],[],[]]
    
    init() {
    }
    
    func toggleLectureAt(section: Int, row: Int){
        if(list[section][row].selected){
            list[section][row].selected = false
        }else{
            list[section][row].selected = true
        }
    }
    
    //liefert alle selektierten Studeingängen
//    func selectedLectures() -> [[Lecture]]{
//        var lectures : [[Lecture]] = []
//        
//        for day in list{
//            for lecture in day{
//                if (lecture.selected){
//                    selectedLectures.append(lec)
//                }
//            }
//        }
//        
//        return selectedLectures
//    }

    func isSelected(section: Int, row: Int) -> Bool{
        return list[section][row].selected
    }
    
    func addSchedule(lectures: [Lecture]){
        
        for lec in lectures{
            switch lec.day {
            case "Montag":
                list[0].append(lec)
            case "Dienstag":
                list[1].append(lec)
            case "Mittwoch":
                list[2].append(lec)
            case "Donnerstag":
                list[3].append(lec)
            case "Freitag":
                list[4].append(lec)
            case "Samstag":
                list[5].append(lec)
            default:
                return
            }
        }
        dump(list)
    }
    
    func getLectureAt(section: Int, row: Int) -> Lecture{
        return list[section][row]
    }
    
    func clearSchedule(){
        list.removeAll()
    }
    
    func sizeAt(section: Int) -> Int{
        return list[section].count
    }
}
