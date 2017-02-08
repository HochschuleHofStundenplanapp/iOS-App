//
//  DataObjectPersistency.swift
//  StundenplanNavigation
//
//  Created by Paul Forstner on 06.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class DataObjectPersistency {
    private let fileName = "data.plist"
    private let dataKey  = "DataObject"
    
    func loadDataObject() -> Settings {
        var item : Settings!
        let file = dataFileForName(fileName: fileName)
        
        if (!FileManager.default.fileExists(atPath: file)) {
            return Settings.sharedInstance
        }
        
        if let data = NSData(contentsOfFile: file) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            item = unarchiver.decodeObject(forKey: dataKey) as! Settings
            unarchiver.finishDecoding()
        }
        
        return item
    }
    
    func saveDataObject(items : Settings) {
        let file = dataFileForName(fileName: fileName)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: dataKey)
        archiver.finishEncoding()
        data.write(toFile: file, atomically: true)
    }
    
    private func documentPath() -> String {
        let allPathes = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return allPathes[0]
    }
    
    private func tmpPath() -> String
    {
        return NSTemporaryDirectory()
    }
    
    private func dataFileForName(fileName : String) -> String {
        return (documentPath() as NSString).appendingPathComponent(fileName)
    }
    
    private func tmpFileForName(fileName : String) -> String {
        return (tmpPath() as NSString).appendingPathComponent(fileName)
    }
}
