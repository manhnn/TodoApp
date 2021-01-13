//
//  Data.swift
//  AppToDo
//
//  Created by Nguyen Manh on 02/01/2021.
//


import UIKit

class Reminder {
    var id = ""
    var taskWorkName = ""
    var taskScheduledDate = Date()
    var taskDueDate = Date()
    var isComplete = false
    var isImportant = false
    var isAddToMyDay = true
    var txtNote = ""
    
    init(id: String, taskName: String, taskScheduledDate: Date, taskDueDate: Date, isComplete: Bool, isImportant: Bool, isAddToMyDay: Bool, txtNote: String) {
        self.id = id
        self.taskWorkName = taskName
        self.taskScheduledDate = taskScheduledDate
        self.taskDueDate = taskDueDate
        self.isComplete = isComplete
        self.isImportant = isImportant
        self.isAddToMyDay = isAddToMyDay
        self.txtNote = txtNote
    }
}

