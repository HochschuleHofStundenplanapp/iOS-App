//
//  SemesterController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 07.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterController: NSObject {

    func toggleSemester(at indexPath: IndexPath) {
        
        let clickedSemester = UserData.sharedInstance.semester(at: indexPath)
        
        if UserData.sharedInstance.selectedSemesters.contains(clickedSemester) {
            let index = UserData.sharedInstance.selectedSemesters.index(of: clickedSemester)
            UserData.sharedInstance.selectedSemesters.remove(at: index!)
            
            //Entfernen zugehörige Vorlesungen
            self.removeLectures(for: clickedSemester)
        }else{
            UserData.sharedInstance.selectedSemesters.append(clickedSemester)
        }
    }
    
    private func removeLectures(for semester: Semester){
        for lecture in UserData.sharedInstance.selectedLectures{
            if(lecture.semester == semester){
                let index = UserData.sharedInstance.selectedLectures.index(of: lecture)
                UserData.sharedInstance.selectedLectures.remove(at: index!)
            }
        }
    }
}
