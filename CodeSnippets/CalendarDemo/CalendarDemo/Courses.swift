//
//  Courses.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Liste aller Studeingänge
class Courses{
    private var list : [Course] = []
    
    init() {}
    
    func toggleCourseAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    //Kürzel zu allen selektierten Studeingängen anzeigen
    func selectedCourses() -> [Course]{
        var selectedCourses : [Course] = []
        
        for course in list{
            if (course.selected){
                selectedCourses.append(course)
            }
        }
        
        return selectedCourses
    }
    
    func selectedCoursesName() -> [String]{
        var selectedCourses : [String] = []
        
        for course in list{
            if (course.selected){
                selectedCourses.append(course.nameDe)
            }
        }
        
        return selectedCourses
    }
    
    //Zu allen Sekektierten Studiengängen die vorhanden Semester anzeigen
    func selectedSemesters() -> [Semesters]{
        
        var semestersArray = [Semesters]()
        
        for course in list{
            if course.selected{
                semestersArray.append(course.semesters)
            }
        }
        return semestersArray
    }
    
    private func mergeCourses(courses: [Course]){
        
        for localCourse in list{
            for loadedCourse in courses{
                if(localCourse.equal(compareTo: loadedCourse)){
                    loadedCourse.selected = localCourse.selected
                }
            }
        }
        list = courses
    }
    
    func addCourses(courses: [Course]){
        if(list.isEmpty){
            list = courses
        }else{
            mergeCourses(courses: courses)
        }
    }
    
    func isSelected(index: Int) -> Bool{
        return list[index].selected
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
