        let lectures = UserData.sharedInstance.selectedSchedule.getOneDimensionalList()
        print("lectures->count\(lectures.count)")
        var jsonLectures : [String: [Any]] = [:]
        var tmpArray: [String] = []
        for item in lectures{
            if !tmpArray.contains(item.splusname){  
                tmpArray.append(item.splusname)
            }
        }
        jsonLectures.updateValue(tmpArray, forKey: "lecture")
        var payload : [String: Any] = ["fcm_token": deviceToken]
        payload.updateValue(tmpArray, forKey: "vorlesung_id")
        
        let osParam = 1
        payload.updateValue(osParam, forKey: "os")