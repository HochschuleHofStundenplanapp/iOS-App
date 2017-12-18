//
//  TaskOverviewViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TaskLectureController {
    
    private func compare(task: Task, with lecture: Lecture, sectionWeekday: Int) -> Bool {
        let equalLecture = lecture.name.contains(task.lecture)
        let weekdayTask = Calendar.current.component(.weekday, from: task.dueDate)
        
        let equalWeekday = sectionWeekday == (weekdayTask - 2) //zB Section der Vorlesung == 0 && Wochentag des Tasks ist Montag -> 2 (Sonntag = 1)
        
        return equalLecture && equalWeekday
    }
    
    func hasTask(for lecture: Lecture, at sectionWeekday: Int) -> Bool {
        for task in UserData.sharedInstance.tasks {
            if compare(task: task, with: lecture, sectionWeekday: sectionWeekday) && !task.checked {
                return true
            }
        }
        return false
    }
}

class TaskOverviewViewController: UIViewController {
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDueDateTextField: UITextField!
    @IBOutlet weak var taskLectureTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    var receivedTask: Task!
    var receivedViewMode: ViewMode!
    var receivedSelectedIndexPath: IndexPath!
    
    var lectureDataSource: UILecturePickerDataSource!
    var lectureDelegate: UILecturePickerDelegate!
    
    var delegate: TaskViewProtocol!
    
    var changedDate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpSpecialKeyboards()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if receivedViewMode != ViewMode.create {
            if changedDate || lectureDelegate.changedValue {
                delegate.changed(filterCriteria: true)
            } else {
                delegate.receive(editedTaskIndexPath: receivedSelectedIndexPath)
            }
        }
    }
    
    func setUpUI() {
        switch receivedViewMode! {
        case .create:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: self, action: #selector(createTaskAction(_:)))
            displayTask()
        case .detail:
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_edit"), style: .done, target: self, action: #selector(editTaskAction(_:))) // TODO: Hier das Bild vom Stift einfügen
            taskTitleTextField.isUserInteractionEnabled = false
            taskDueDateTextField.isUserInteractionEnabled = false
            taskLectureTextField.isUserInteractionEnabled = false
            taskDescriptionTextView.isUserInteractionEnabled = false
            
            taskTitleTextField.borderStyle = .none
            taskDueDateTextField.borderStyle = .none
            taskLectureTextField.borderStyle = .none
            displayTask()
        case .edit:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: self, action: #selector(displayTaskAction(_:)))
            
            taskTitleTextField.borderStyle = .roundedRect
            taskDueDateTextField.borderStyle = .roundedRect
            taskLectureTextField.borderStyle = .roundedRect
            
            taskTitleTextField.isUserInteractionEnabled = true
            taskDueDateTextField.isUserInteractionEnabled = true
            taskLectureTextField.isUserInteractionEnabled = true
            taskDescriptionTextView.isUserInteractionEnabled = true
            displayTask()
        }
    }
    
    func setUpSpecialKeyboards() {
        // Montag, dd.MM.yyyy
        let datePicker = UIDatePicker()
        datePicker.date = receivedTask.dueDate
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        taskDueDateTextField.inputView = datePicker
        
        // Lecute Name
        let lecturePicker = UIPickerView()
        lectureDataSource = UILecturePickerDataSource()
        lectureDelegate = UILecturePickerDelegate()
        lectureDelegate.displaySelectedResult(on: taskLectureTextField)
        lecturePicker.dataSource = lectureDataSource
        lecturePicker.delegate = lectureDelegate
        lecturePicker.backgroundColor = UIColor.white
        taskLectureTextField.inputView = lecturePicker
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        receivedTask.dueDate = sender.date
        displayDueDate()
        changedDate = true
    }
    
    private func displayDueDate() {
        let date = receivedTask.dueDate
        taskDueDateTextField.text = date.formattedDate
    }
    
    @objc func createTaskAction(_ sender: UIBarButtonItem) {
        print("Create Task Aktion")
        let userFilledAllTaskInformation = true
        saveTask(shouldAppend: true)
        if userFilledAllTaskInformation {
            delegate.addedNewTask(otherVC: self)
        }
    }
    
    @objc func editTaskAction(_ sender: UIBarButtonItem) {
        print("Edit Task Aktion")
        receivedViewMode = ViewMode.edit
        saveTask()
        setUpUI()
    }
    
    @objc func displayTaskAction(_ sender: UIBarButtonItem) {
        print("Display Task Aktion")
        receivedViewMode = ViewMode.detail
        saveTask()
        setUpUI()
    }
    
    private func saveTask(shouldAppend appendTask: Bool = false) {
        receivedTask.title = taskTitleTextField.text!
        receivedTask.lecture = taskLectureTextField.text!
        receivedTask.taskDescription = taskDescriptionTextView.text!
        
        guard let task = receivedTask else {
            DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
            return
        }
        
        //Task wird angehängt
        if appendTask {
            UserData.sharedInstance.tasks.append(task)
            
        }
        //Task wird gelöscht
        else {
            CalendarInterface.sharedInstance.removeTaskFromCalendar(task: task)
        }
        
        CalendarInterface.sharedInstance.addTaskToCalendar(task: task)
        DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
    }
    
    private func displayTask() {
        taskTitleTextField.text = receivedTask.title
        displayDueDate()
        taskLectureTextField.text = receivedTask.lecture
        taskDescriptionTextView.text = receivedTask.taskDescription
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taskTitleTextField.resignFirstResponder()
        taskDueDateTextField.resignFirstResponder()
        taskLectureTextField.resignFirstResponder()
        taskDescriptionTextView.resignFirstResponder()
    }
    
    enum ViewMode {
        case create
        case edit
        case detail
    }
    
}
