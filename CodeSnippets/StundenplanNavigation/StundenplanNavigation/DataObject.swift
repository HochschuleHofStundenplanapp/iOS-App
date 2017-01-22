//
//  dataObject.swift
//  persistence
//

import Foundation


//
//  Data-Container
//
class DataObject : NSObject, NSCoding {
    fileprivate var version : Int = 1

    
    fileprivate let versionKey = "version_Key"

    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        doDecoding(aDecoder)
    }
    
    fileprivate func doDecoding(_ aDecoder : NSCoder)
    {
        version = Int(aDecoder.decodeInt64(forKey: versionKey))

    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(version, forKey:versionKey)

    }
    
}

// ###########################################################################################################

//
// Zugriffsschicht
//
extension DataObject {
    
    var Version : Int {
        get {
            return version
        }
        set (newValue) {
            version = newValue
        }
    }
    
}

// ##########################################################################################################

//
// Persistency Manager
//
class VersionDataObjectPersistency {
    fileprivate let fileName = "version.plist"
    fileprivate let dataKey  = "DataObject"
    
    func loadDataObject() -> DataObject {
        var item : DataObject!
        let file = dataFileForName(fileName)
        
        if (!FileManager.default.fileExists(atPath: file)) {
            return DataObject()
        }
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: file)) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            item = unarchiver.decodeObject(forKey: dataKey) as! DataObject
            unarchiver.finishDecoding()
        }
        
        return item
    }
    
    func saveDataObject(_ items : DataObject) {
        let file = dataFileForName(fileName)
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: dataKey)
        archiver.finishEncoding()
        data.write(toFile: file, atomically: true)
        
    }
    
    fileprivate func documentPath() -> String {
        let allPathes = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return allPathes[0]
    }
    
    fileprivate func tmpPath() -> String
    {
        return NSTemporaryDirectory()
    }
    
    fileprivate func dataFileForName(_ fileName : String) -> String {
        return (documentPath() as NSString).appendingPathComponent(fileName)
    }
    
    fileprivate func tmpFileForName(_ fileName : String) -> String {
        return (tmpPath() as NSString).appendingPathComponent(fileName)
    }
}
