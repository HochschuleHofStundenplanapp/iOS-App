//
//  Task.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

public class Task : NSObject, NSCoding {
    public var title: String
    public var dueDate: Date
    public var lecture: String
    public var taskDescription: String
    public var checked: Bool
    
    override public init() {
        self.title = ""
        self.dueDate = Date()
        self.taskDescription = ""
        self.lecture = ""
        self.checked = false
    }
    
    public init(title: String, dueDate: Date, taskDescription: String, lecture: String) {
        self.title = title
        self.dueDate = dueDate
        self.taskDescription = taskDescription
        self.lecture = lecture
        self.checked = false
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(dueDate, forKey: dueDateKey)
        aCoder.encode(lecture, forKey: lectureKey)
        aCoder.encode(taskDescription, forKey: taskDescriptionKey)
        aCoder.encode(checked, forKey: checkedKey)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: titleKey) as! String
        dueDate = aDecoder.decodeObject(forKey: dueDateKey) as! Date
        lecture = aDecoder.decodeObject(forKey: lectureKey) as! String
        taskDescription = aDecoder.decodeObject(forKey: taskDescriptionKey) as! String
        checked = aDecoder.decodeBool(forKey: checkedKey)
    }
    
    private let titleKey = "titleKey"
    private let dueDateKey = "dueDateKey"
    private let lectureKey = "lectureKey"
    private let taskDescriptionKey = "taskDescriptionKey"
    private let checkedKey = "checkedKey"
    
}
