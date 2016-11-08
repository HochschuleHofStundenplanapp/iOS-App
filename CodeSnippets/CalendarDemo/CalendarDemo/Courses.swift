//
//  Courses.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

class Courses{
    private var list : [Course] = []
    
    static let sharedInstance = Courses()
    private init() {}
    
    func toggleCourseAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    //Kürzel zu allen selektierten Studeingängen anzeigen
    func selectedCourses(){
        
    }
    
    //Zu allen Sekektierten Studiengängen die Semester anzeigen
    func selectedSemesters(){
        
    }
    
    func isSelected(index: Int) -> Bool{
        return list[index].selected
    }
    
    func addCourses(courses: [Course]){
        list = courses
    }
    
    func getCourseAt(index: Int) -> Course{
        return list[index]
    }
    
    func clearCourses(){
        list.removeAll()
    }
    
    func size() -> Int{
        return list.count
    }
}
