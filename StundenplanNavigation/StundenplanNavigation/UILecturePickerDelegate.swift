//
//  UILecturePickerDelegate.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 19.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class UILecturePickerDelegate : NSObject, UIPickerViewDelegate {
    private var resultTextField: UITextField?
    var changedValue: Bool = false
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dSource = pickerView.dataSource as! UILecturePickerDataSource
        let title = dSource.getTitle(for: row)
        return title
    }
    
    func displaySelectedResult(on textField: UITextField) {
        resultTextField = textField
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dSource = pickerView.dataSource as! UILecturePickerDataSource
        let lectureName = dSource.getTitle(for: row)
        resultTextField?.text = lectureName
        changedValue = true
    }
}
