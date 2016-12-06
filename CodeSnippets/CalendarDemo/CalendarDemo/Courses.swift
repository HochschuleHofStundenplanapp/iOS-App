//
//  Courses.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Liste aller Studeingänge
class Courses : NSCopying{
    private var list : [Course] = []
    
    init(){ }
    
    init(courses: [Course]) {
        list = courses
    }
    
    required init?(coder aDecoder: NSCoder) {
        list = aDecoder.decodeObject(forKey: "coursesList") as! [Course]
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encode(list, forKey:"coursesList")
    }
    
    func toggleCourseAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    //Liefert alle selektierten Studeingänge
    func selectedCourses() -> [Course]{
        var selectedCourses : [Course] = []
        
        for course in list{
            if (course.selected){
                selectedCourses.append(course)
            }
        }
        
        return selectedCourses
    }
    
    //Liefert alle Namen aller selektierten Studeingängen
    func selectedCoursesName() -> [String]{
        var selectedCourses : [String] = []
        
        for course in list{
            if (course.selected){
                selectedCourses.append(course.nameDe)
            }
        }
        
        return selectedCourses
    }
    
    //Liefert zu allen selektierten Studiengängen vorhande Semester
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
                    localCourse.semesters.mergeSemesters(semesters: loadedCourse.semesters.list)
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
    
    func size() -> Int{
        return list.count
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Courses(courses: self.list)
        return copy
    }
}
