//
//  Courses.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Liste aller Studeingänge
class Courses : NSObject, NSCopying, NSCoding{
    var list : [Course] = []
    let listKey = "coursesList"
    
    override init(){ }
    
    init(courses: [Course]) {
        super.init()
        for course in courses{
            self.list.append(course.copy() as! Course)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        list = aDecoder.decodeObject(forKey: listKey) as! [Course]
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(list, forKey: listKey)
    }
    
    func toggleCourseAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    //Prüft ob ein oder mehrere Studiengänge selektiert wurden
    func hasSelectedCourses() -> Bool{        
        for course in list{
            if (course.selected){
                return true
            }
        }
        return false
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
    
    func setSelektion(courses: Courses){
        
        for course in courses.list{
            if(course.selected){
                for localCourse in list{
                    if(localCourse.equal(compareTo: course)){
                        localCourse.selected = true
                        localCourse.semesters.setSelektion(semesters: course.semesters)
                    }
                }
            }
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
