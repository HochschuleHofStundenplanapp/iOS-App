//
//  ScheduleChangesController.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf on 20.04.17.
//  Copyright © 2017 Haxnpeter. All rights reserved.
//

import UIKit

class ScheduleChangesController: NSObject, DataObserverProtocol,myObservable{
    
    var myJobManager : JobManager = JobManager()
    let season = UserData.sharedInstance.selectedSeason
    var selectedLectures = UserData.sharedInstance.selectedLectures
    var myObservers = [myObserverProtocol]()
    var myUrl : String = ""
    var myUrlList = [String]()

    override init()
    {
        super.init()
        self.myJobManager.addNewObserver(o: self)

    }
    func handleAllChanges() -> Void
    {
          selectedLectures = UserData.sharedInstance.selectedLectures
      //  self.myJobManager = JobManager()
        
        //Settings.sharedInstance.savedChanges.changes = []
        // cntChanges = 0
        ServerData.sharedInstance.allChanges.removeAll()
        var myUrl = "\(Constants.baseURI)client.php?f=Changes&id[]="
        print("selected lectures size \(selectedLectures.count)")
        for lecture in selectedLectures{
            print("lecture splus\(lecture.splusname)")
            var splusname = lecture.splusname
            splusname = splusname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
           
           
            print("url länge: \(myUrl.characters.count)")
            if(myUrl.characters.count < 5000)
            {
                myUrl = myUrl + "\(splusname)&id[]="

            }
            else
            {
                print("füge myurl der liste hinzu")
                myUrlList.append(myUrl)
                myUrl = "\(Constants.baseURI)client.php?f=Changes&id[]="
                myUrl = myUrl + "\(splusname)&id[]="

            }
            
            
            
            
        }
        
        print(" die ganze url \(myUrl)")
        print("myurlListe größe \(myUrlList.count)")
        for url in myUrlList
        {
            print("url \(url)")
            myJobManager.NetworkJob(url: url, username: Constants.username, password: Constants.password, isLastJob: false)
           
        }
       
        
            myJobManager.NetworkJob(url: myUrl, username: Constants.username, password: Constants.password, isLastJob: true)
        
        
     
        
    }

    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void
    {
        print("Das Dataobject \(o)")
        let dataArray = o as! [(Data?, Error?)]
        
       
        
        for dataObject in dataArray {
            //print(String(data: dataObject.0!, encoding: String.Encoding.utf8)! as String)
            
            if dataObject.1 != nil{
                // handle error
            }
            
            guard dataObject.0 != nil else {
                return
            }
            print(String(data: dataObject.0!, encoding: String.Encoding.utf8)! as String)
            //TODO: JsonChanges muss umgeschrieben werden - Darf kein Course erwarten ..
            
            //ServerData.sharedInstance.allChanges = (JsonChanges(data: dataObject.0!)?.changes)!
            
            for change in (JsonChanges(data: dataObject.0!)?.changes)!
            {
                ServerData.sharedInstance.allChanges.append(change)
            }
            
          //  print( "kappacount \(ServerData.sharedInstance.allChanges.count)")
            
            notifiyAllObservers(s: "fertig")
            
        }
        
     print("ScheduleChanges Controller All Jobs Done")
        
    }
    /// Bricht im JobManager alle Netzwerkjobs ab
   func cancelAllNetworkJobs() -> Void  {
        myJobManager.cancelAllNetworkJobs()
        
    }
    
    func notifiyAllObservers(s: String?) -> Void
    {
        for observer in myObservers
        {
            print("DataObserver wird benachrichtigt")
            observer.update(s: "update")
        }
    }
    
    func addNewObserver (o: myObserverProtocol) -> Void
    {
        myObservers.append(o)
    }
    
    func removeOldObserver (o: myObserverProtocol) -> Void
    {
        if let i = myObservers.index(where: { $0 === o }) {
            myObservers.remove(at: i)
            print("DataObserver wurde entfernt")
        }
    }
    
}
