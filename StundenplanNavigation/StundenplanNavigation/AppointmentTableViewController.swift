//
//  AppointmentTableViewController.swift
//  StundenplanNavigation
//
//  Created by Bastian Kusserow on 08.01.18.
//  Copyright © 2018 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

class AppointmentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //let userData = UserData.sharedInstance
    
    @IBOutlet weak var textInfo: UITextView!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let htmlText = "Hinweis: Experimentelles Feature, Daten können abweichen. Offizielle Termine finden Sie auf der <a href='http://www.hof-university.de/studierende/studienbuero/termine.html'>Website</a>."

        textInfo.attributedText = htmlText.convertHtml()
        textInfo.isEditable = false
        textInfo.dataDetectorTypes = .link
        textInfo.font = UIFont.systemFont(ofSize: 17)
        
    }
    
    @IBAction func butReload(_ sender: UIButton) {
        print("parse appointments again...")
        let parser = AppointmentParser()
        parser.delegate = self
        parser.downloadAndParseAppointmentContent()
    }
    
    func reloadAppointments() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return UserData.sharedInstance.appointments.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserData.sharedInstance.appointments[section].appointments.count
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UserData.sharedInstance.appointments[section].header
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        formatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        let appointment = UserData.sharedInstance.appointments[indexPath.section].appointments[indexPath.row]
        cell.textLabel?.text = appointment.name
        cell.detailTextLabel?.text = "\(formatter.string(from: appointment.date.start)) \(appointment.date.start == appointment.date.end ? "" : "-" + formatter.string(from: appointment.date.end))"
        
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data,
                                          options: [.documentType : NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue
                                                    ], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
