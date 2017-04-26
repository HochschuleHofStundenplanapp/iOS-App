//
//  ServerData.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 26.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class ServerData: NSObject {

    var allCourses : [Course] = []
    var allSemester : [Semester] = []
    var allLectures : [Lecture] = []
    
    func testSetup() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "de_DE")
        
        let startDate = dateFormatter.date(from: "12.01.2017 8:00")
        let endDate = dateFormatter.date(from: "12.01.2017 9:30")
        
        let course1 = Course(contraction : "MC", nameDe: "Mobile Computing", nameEn: "Mobile Computing")
        let course2 = Course(contraction : "MB", nameDe: "Maschinenbau", nameEn: "Mechanical Engineering")
        let semester1 = Semester(name: "6", course: course1)
        let semester2 = Semester(name: "2", course: course2)
        let lecture1 = Lecture(id: 1234567, name: "OOP 1", lecturer: "Bachmann", type: "Übung", group: "A", startdate: startDate!, enddate: endDate!, day: "Montag", room: "FA 102", semester: semester1, comment : "Comment", iteration: 7)
        let lecture2 = Lecture(id: 1234567, name: "Dynamic", lecturer: "Herbert", type: "Testat", group: "C", startdate: startDate!, enddate: endDate!, day: "Freitag", room: "FA 120", semester: semester2, comment : "KommentR", iteration: 7)
        
        allCourses.append(course1)
        allCourses.append(course2)
        
        allSemester.append(semester1)
        allSemester.append(semester2)
        
        allLectures.append(lecture1)
        allLectures.append(lecture2)
    }
    
    static var sharedInstance = ServerData()
    private override init(){
        super.init()
        testSetup()
    }
    
    var coursesSize: Int {
        get { return allCourses.count }
    }
    
    var semestersSize: Int {
        get { return allSemester.count }
    }
    
    var lecturesSize: Int {
        get { return allLectures.count }
    }
    
    func course(at index: Int) -> Course{
        return allCourses[index]
    }
    
    func semester(at index: Int) -> Semester{
        return allSemester[index]
    }
    
    func lecture(at index: Int) -> Lecture{
        return allLectures[index]
    }
   
}
