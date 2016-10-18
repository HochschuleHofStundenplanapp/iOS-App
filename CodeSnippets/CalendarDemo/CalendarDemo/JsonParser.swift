//
//  JsonParser.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

// Basiert auf SwiftyJSON --- https://github.com/SwiftyJSON/SwiftyJSON
import Foundation

enum JSONData {
    case jsonObject([String:JSONData])
    case jsonArray([JSONData])
    case jsonString(String)
    case jsonNumber(NSNumber)
    case jsonBool(Bool)
    
    var object : [String : JSONData]? {
        switch self {
        case .jsonObject(let aData):
            return aData
        default:
            return nil
        }
    }
    
    var array : [JSONData]? {
        switch self {
        case .jsonArray(let aData):
            return aData
        default:
            return nil
        }
    }
    
    var string : String? {
        switch self {
        case .jsonString(let aData):
            return aData
        default:
            return nil
        }
    }
    
    var integer : Int? {
        switch self {
        case .jsonNumber(let aData):
            return aData.intValue
        default:
            return nil
        }
    }
    
    var bool: Bool? {
        switch self {
        case .jsonBool(let value):
            return value
        default:
            return nil
        }
    }
    
    subscript(i: Int) -> JSONData? {
        get {
            switch self {
            case .jsonArray(let value):
                return value[i]
            default:
                return nil
            }
        }
    }
    
    subscript(key: String) -> JSONData? {
        get {
            switch self {
            case .jsonObject(let value):
                return value[key]
            default:
                return nil
            }
        }
    }
    
    static func fromObject(_ object: AnyObject) -> JSONData? {
        switch object {
        case let value as String:
            return JSONData.jsonString(value as String)
        case let value as NSNumber:
            return JSONData.jsonNumber(value)
        case let value as NSDictionary:
            var jsonObject: [String:JSONData] = [:]
            for (key, value) : (Any, Any) in value {
                if let key = key as? String {
                    if let value = JSONData.fromObject(value as AnyObject) {
                        jsonObject[key] = value
                    } else {
                        return nil
                    }
                }
            }
            return JSONData.jsonObject(jsonObject)
        case let value as NSArray:
            var jsonArray: [JSONData] = []
            for v in value {
                if let v = JSONData.fromObject(v as AnyObject) {
                    jsonArray.append(v)
                } else {
                    return nil
                }
            }
            return JSONData.jsonArray(jsonArray)
        default:
            return nil
        }
    }
    
}
