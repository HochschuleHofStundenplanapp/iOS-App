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
        
        let clickedSemester = TmpSelectedSemesters().semester(at: indexPath)
        
        if TmpSelectedSemesters().contains(semester: clickedSemester) {
            
            //Semester deselektieren
            TmpSelectedSemesters().remove(semester: clickedSemester)
            
            //Entfernen zugehörige Vorlesungen
            TmpSelectedLectures().removeLectures(for: clickedSemester)
        }else{
            //Selektiertes Semester speichern 
            TmpSelectedSemesters().append(semester: clickedSemester)
        }
    }
}
