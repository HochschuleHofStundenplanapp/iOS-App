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
            TmpSelectedLectures().removeLectures(for: clickedSemester)
        }else{
            UserData.sharedInstance.selectedSemesters.append(clickedSemester)
        }
    }
    
    
}
