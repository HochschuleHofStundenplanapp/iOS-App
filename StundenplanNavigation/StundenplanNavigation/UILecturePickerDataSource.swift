//
//  UILecturePickerDataSource.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 19.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework
class UILecturePickerDataSource : NSObject, UIPickerViewDataSource {
    private var lectureNames: [String] = []
    
    override init() {
        let allLecturesDuplicates = UserData.sharedInstance.selectedSchedule.getOneDimensionalList()
        var allLectureNames: [String] = []
        for lecture in allLecturesDuplicates {
            
            // Manche Lectures haben ein Datum vor ihrem Namen: "xx.xx Sport und Gesundheit"
            // TODO: kann man auch besser lösen ...
            var name = lecture.name
            if name.count >= 4 {
                let prefix = name[name.startIndex...name.index(name.startIndex, offsetBy: String.IndexDistance(4))]
                if Double(prefix) != nil {
                    name = String(name[name.index(name.startIndex, offsetBy: String.IndexDistance(5))..<name.endIndex])
                }
            }
            
            allLectureNames.append(name)
        }
        lectureNames = Array(Set(allLectureNames))
        lectureNames.sort()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lectureNames.count
    }
    
    func getTitle(for row: Int) -> String {
        return lectureNames[row]
    }
}
