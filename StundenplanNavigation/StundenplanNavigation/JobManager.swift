//
//  JobManager.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf on 20.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class JobManager: NSObject, DataObservableProtocol, JobDataObserverProtocol{

    var myObservers: [DataObserverProtocol] = [DataObserverProtocol]()
    var jobQueueArray : [AnyObject] = []
    var lastJobSubmitted : Bool = false
    var jobGroup: DispatchGroup = DispatchGroup()
    var workItemArray : [DispatchWorkItem] = [DispatchWorkItem]()
    var position : Int = -1
    var isCanceled : Bool = false
    
    override init() {
      
       super.init()
        
   

    }
    
    func resetAll()
    {
      
        jobQueueArray  = []
        lastJobSubmitted = false
       jobGroup = DispatchGroup()
    workItemArray  = [DispatchWorkItem]()
        self.position = -1
        isCanceled = false
        

    }
    
    /// Startet einen NetworkJob, welcher der Queueue hinzugefügt wird.
    func NetworkJob(url: String, username: String? = nil, password: String? = nil, isLastJob: Bool? = nil ) -> Void
    {
     
        if(isCanceled)
        {
            resetAll()
            isCanceled = false
            return
        }
        
        self.position += 1
        let p = self.position
         jobQueueArray.append("Wait for data" as AnyObject)

        print("Jobposition wird gesetzt: \(position)" )
        if(!lastJobSubmitted)
        {
            //jobGroup wird beigetreten
            
            //Erstelle DispatchworkItem
            let workItem = DispatchWorkItem()
                {
                    
                    
                    let myGetDataFromInternet = GetDataFromInternet()
                    myGetDataFromInternet.addNewObserver(o: self)
                    myGetDataFromInternet.doItWithUrl(url: url, username: username, password: password,position: p)
                }
            
            //füge den workItemArray das vorherig Erstellte workItem hinzu.
            workItemArray.append(workItem)
            
            if(isLastJob == true)
            {
                for job in workItemArray
                {
                   
                    print("job Ausführen")
                    
                    jobGroup.enter()
                    
                    //Führe workItem aus
                     DispatchQueue.global(qos: .userInitiated).async(execute: job)
                  

                }
       
                jobGroup.notify(queue: DispatchQueue.main, execute: {() -> Void in
                    self.notifiyAllObservers(o: self.jobQueueArray as AnyObject)
                    self.lastJobSubmitted = false
                    
                }
                )

                lastJobSubmitted = true
            }
            
        }
        
        
    }
    
    /// Bricht alle Netzwerkjobs ab
    func cancelAllNetworkJobs() -> Void
    {
        
        for job in self.workItemArray
        {
            
            job.cancel()
          
        }
        self.isCanceled = true
      // resetAll()
  print("All NetworkJobs Canceled")
    }
    
    
    /// Fügt einen neuen Observer der Klasse JobManager hinzu
    ///
    /// - parameter o: Die Observerklasse, welche DataObserverProtocol implementiert
    func addNewObserver (o: DataObserverProtocol) -> Void
    {
        myObservers.append(o)
        print("DataObserver wird hinzugefügt")
    }
    
    /// Entfernt den übergebenen Observer von der Klasse Settings
    ///
    /// - parameter o: o Die Observerklasse, welche DataObserverProtocol implementiert
    func removeOldObserver (o: DataObserverProtocol) -> Void
    {
        if let i = myObservers.index(where: { $0 === o }) {
            myObservers.remove(at: i)
            print("DataObserver wurde entfernt")
        }

    }
    /// Benachrichtigt alle Observer über eine Veränderung
    ///
    ///
    func notifiyAllObservers(o: AnyObject) -> Void
    {
        if(!isCanceled)
        {
        
        for observer in myObservers
        {
            observer.update(o: o)
        }
        }
        //Reset position für neue Jobs
      //  resetAll()
        
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    /// wird durch die zu observierende unterklasse (GetDataFromInternet) aufgerufen
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject, p: Int) -> Void
    {
        
     
        print("Jobposition kommt zurück in update: \(p)" )
        
      
        if(!isCanceled)
        {
     

        //todo: an richtige position des Arrays speichern, id wird mit hochgegeben.
        jobQueueArray[p] = o
        jobGroup.leave()
        
            
        }
      
       
    }
    

    
    
}
