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
    var list : [Lecture] = []
    
    func toggleLctureAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }

    func isSelected(index: Int) -> Bool{
        return list[index].selected
    }
    
    func addSchedule(lectures: [Lecture]){
        list.append(contentsOf: lectures)
        
        //Ausgabe der Liste
        print("APPENDED")
        for i in list{
        print(i.name)
        }
    }
    
    func getLectureAt(index: Int) -> Lecture{
        return list[index]
    }
    
    func clearLectures(){
        list.removeAll()
    }
    
    func size() -> Int{
        return list.count
    }
}
