//
//  TmpSelectedLectures.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 03.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TmpSelectedLectures: NSObject {

    fileprivate var userdata: UserData
    
    init(userdata: UserData){
        self.userdata = userdata
    }
    
    func numberOfEntries(for section : Int) -> Int
    {
        return userdata.selectedSchedule.daySize(at: section)
    }
    
    func getElement(at indexPath : IndexPath) -> Lecture
    {
        return userdata.selectedSchedule.lecture(at: indexPath)
    }
    
    func getIndexPath(for element: Lecture) -> IndexPath{
        
        var iP = NSIndexPath()
        
        let lectures = userdata.selectedSchedule.lectures
        
        for i in 0..<lectures.count{
            for j in 0..<lectures[i].count{
                if lectures[i][j] == element{
                    iP = NSIndexPath(row: j, section: i)
                }
            }
        }
        return iP as IndexPath
    }
    
    func set(lectures: [[Lecture]]) {
        userdata.selectedSchedule.lectures = lectures
    }
    
    func add(lecture : Lecture, at day : Int){
        userdata.selectedSchedule.add(lecture: lecture, at: day)
    }
    
    func add(lecture : Lecture){
        let dayIndex = Constants.weekDays.index(of: lecture.day)!
        userdata.selectedSchedule.add(lecture: lecture, at: dayIndex)
    }
    
    func clear() {
        userdata.selectedSchedule.clear()
    }
    
    func remove(at indexPath: IndexPath){
        userdata.selectedSchedule.removeLecture(at: indexPath)
    }
    
    func removeLectures(with course: Course){
        
        var lecturesToBeDeleted : [Lecture] = [Lecture]()
        
        for day in userdata.selectedSchedule.lectures{
            for lecture in day{
                if(lecture.semester.course == course){
                    
                    lecturesToBeDeleted.append(lecture)
                }
            }
        }
        
        for lecture in lecturesToBeDeleted{
            
            let i = Constants.weekDays.index(of: lecture.day)!
            removeLecture(lecture: lecture, day: i)
        }
    }
    
    func removeLectures(for semester: Semester){
        
        var lecturesToBeDeleted : [Lecture] = [Lecture]()
        
        for day in userdata.selectedSchedule.lectures{
            for lecture in day{
                if(lecture.semester == semester){
                    
                    lecturesToBeDeleted.append(lecture)
                }
            }
        }
        
        for lecture in lecturesToBeDeleted{
            
            let i = Constants.weekDays.index(of: lecture.day)!
            removeLecture(lecture: lecture, day: i)
        }
    }
    
    func contains(lecture: Lecture) -> Bool{
        return userdata.selectedSchedule.contains(lecture: lecture)
    }
    
    private func removeLecture(lecture : Lecture, day : Int){
        if let index = userdata.selectedSchedule.lectures[day].index(of: lecture){
            userdata.selectedSchedule.lectures[day].remove(at: index)
        }
    }
    
    func getOneDimensionalList() -> [Lecture]{
//        let lectures = userdata.selectedSchedule.lectures
//        
//        var newList : [Lecture] = [Lecture]()
//        
//        for day in lectures{
//            for lecture in day{
//                newList.append(lecture)
//            }
//        }
//        return newList
        let list = userdata.selectedSchedule.getOneDimensionalList()
        return list
    }
}
