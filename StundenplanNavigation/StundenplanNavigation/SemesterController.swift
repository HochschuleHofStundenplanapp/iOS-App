//
//  SemesterController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 07.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterController: NSObject {

    var tmpSelectedLectures : TmpSelectedLectures
    var tmpSelectedSemesters : TmpSelectedSemesters
    
    init (tmpSelectedLectures: TmpSelectedLectures, tmpSelectedSemesters : TmpSelectedSemesters){
        self.tmpSelectedLectures = tmpSelectedLectures
        self.tmpSelectedSemesters = tmpSelectedSemesters
    }
    
    func toggleSemester(at indexPath: IndexPath) {
        
        let clickedSemester = tmpSelectedSemesters.semester(at: indexPath)
        
        if tmpSelectedSemesters.contains(semester: clickedSemester) {
            
            //Semester deselektieren
            tmpSelectedSemesters.remove(semester: clickedSemester)
            
            //Entfernen zugehörige Vorlesungen
            tmpSelectedLectures.removeLectures(for: clickedSemester)
        }else{
            //Selektiertes Semester speichern 
            tmpSelectedSemesters.append(semester: clickedSemester)
        }
    }
}
