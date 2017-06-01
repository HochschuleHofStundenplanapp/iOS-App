//
//  SelectedLectures.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SelectedLectures: NSObject {
    
    fileprivate var userdata = UserData.sharedInstance
    
    func numberOfEntries(for section : Int) -> Int
    {
        return userdata.selectedLectures.daySize(at: section)
    }
    
    func getElement(at indexPath : IndexPath) -> Lecture
    {
        return userdata.selectedLectures.lecture(at: indexPath)
    }
    
    func getIndexPath(for element: Lecture) -> IndexPath{
    
        var iP = NSIndexPath()
        
        let lectures = userdata.selectedLectures.allLectures
        
        for i in 0..<lectures.count{
            for j in 0..<lectures[i].count{
                if lectures[i][j] == element{
                    iP = NSIndexPath(row: j, section: i)
                }
            }
        }
        return iP as IndexPath
    }
    
        
    func add(lecture : Lecture, at day : Int){
        userdata.selectedLectures.add(lecture: lecture, at: day)
    }
    
    func add(lecture : Lecture){
        
        let dayIndex = Constants.weekDays.index(of: lecture.day)!
        
        userdata.selectedLectures.add(lecture: lecture, at: dayIndex)
    }
    
    func getOneDimensionalList() -> [Lecture]{
    //Noch nicht getestet

        let lectures = userdata.selectedLectures.allLectures
        
        var newList : [Lecture] = [Lecture]()
        
        for day in lectures{
            for lecture in day{
                newList.append(lecture)
            }
        }
        return newList
    }
    
    func clear()
    {
        userdata.selectedLectures.clear()
    }
    
    func contains(lecture: Lecture) -> Bool{
    //Noch nicht getestet
        
        let lectures = userdata.selectedLectures.allLectures
        
        for day in lectures{
            for lec in day{
                if lec == lecture{
                    return true
                }
            }
        }
    
        return false
    }
    
    func remove(at indexPath: IndexPath){
    
        userdata.selectedLectures.removeLecture(at: indexPath)
    }
    
    //Folgende Remove Methoden wurden noch nicht getestet
    func removeLectures(with course: Course){
        
        var lecturesToBeDeleted : [Lecture] = [Lecture]()
        
        for day in userdata.selectedLectures.allLectures{
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
        
        for day in userdata.selectedLectures.allLectures{
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
    
    private func removeLecture(lecture : Lecture, day : Int){
        if let index = userdata.selectedLectures.allLectures[day].index(of: lecture){
            userdata.selectedLectures.allLectures[day].remove(at: index)
        }
    }
}
