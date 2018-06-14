//
//  DataObjectPersistency.swift
//  StundenplanNavigation
//
//  Created by Paul Forstner on 06.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//


public class DataObjectPersistency {
    private let fileName = "data_v4.plist"
    private let dataKey  = "Data2Object"
    private let fileNameCalendar = "CalendarIDList_v4.plist"
    private let IDListKey = "IDList"
    
    public init() {
        
    }
    
    public func loadDataObject() -> UserData {
        var item : UserData!
        var file = dataFileForName(fileName: fileName)
        
        if (!FileManager.default.fileExists(atPath: file)) {
            file = newDataFileForName(fileName: fileName)
            
            if(!FileManager.default.fileExists(atPath: file)){
                return UserData.sharedInstance
            }
        }
        
        if let data = NSData(contentsOfFile: file) {
            let unarchiver = setupUnarchiver(data: data)
            item = unarchiver.decodeObject(forKey: dataKey) as! UserData
            unarchiver.finishDecoding()
        }
        
        return item
    }
    
    // Wenn auf dem Gerät die App ohne AppGroup und ohne Framework installiert war, müssen beim Unarchiver
    // Klassennamen neu auf die entsprechenden Klassen gemappt werden
    private func setupUnarchiver(data: NSData) -> NSKeyedUnarchiver{
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
        unarchiver.setClass(UserData.self, forClassName: "StundenplanNavigation.UserData")
        unarchiver.setClass(Course.self, forClassName: "StundenplanNavigation.Course")
        unarchiver.setClass(Semester.self, forClassName: "StundenplanNavigation.Semester")
        unarchiver.setClass(Schedule.self, forClassName: "StundenplanNavigation.Schedule")
        unarchiver.setClass(Lecture.self, forClassName: "StundenplanNavigation.Lecture")
        unarchiver.setClass(ChangedLecture.self, forClassName: "StundenplanNavigation.ChangedLecture")
        
        return unarchiver
    }
    
    public func saveDataObject(items : UserData) {
        let file = dataFileForName(fileName: fileName)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: dataKey)
        archiver.finishEncoding()
        data.write(toFile: file, atomically: true)
        print("user data saved")
    }
    
    public func loadCalendarData() -> CalendarData {
        var item : CalendarData!
        let file = dataFileForName(fileName: fileNameCalendar)
        
        if (!FileManager.default.fileExists(atPath: file)) {
            return CalendarData.sharedInstance
        }
        
        if let data = NSData(contentsOfFile: file) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            item = unarchiver.decodeObject(forKey: IDListKey) as! CalendarData
            unarchiver.finishDecoding()
        }
        
        return item
    }
    
    public func saveCalendarData(items : CalendarData) {
        let file = dataFileForName(fileName: fileNameCalendar)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: IDListKey)
        archiver.finishEncoding()
        data.write(toFile: file, atomically: true)
    }
    
    private func oldDocumentPath() -> String {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return allPaths[0]
    }
    
    private func documentPath() -> String {
        
        let fileManager = FileManager.default
        let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupID)
        
        return container!.path
    }
    
    private func tmpPath() -> String
    {
        return NSTemporaryDirectory()
    }
    
    private func dataFileForName(fileName : String) -> String {
        return (documentPath() as NSString).appendingPathComponent(fileName)
    }
    
    private func newDataFileForName(fileName: String) -> String {
        return (oldDocumentPath() as NSString).appendingPathComponent(fileName)
    }
    
    private func tmpFileForName(fileName : String) -> String {
        return (tmpPath() as NSString).appendingPathComponent(fileName)
    }
}
