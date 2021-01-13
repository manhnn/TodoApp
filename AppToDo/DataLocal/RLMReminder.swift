//
//  RLMReminder.swift
//  AppToDo
//
//  Created by Nguyen Manh on 11/01/2021.
//

import Foundation
import RealmSwift

class RLMReminder: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var taskWorkName = ""
    @objc dynamic var taskScheduledDate = ""
    @objc dynamic var taskDueDate = ""
    @objc dynamic var isComplete = false
    @objc dynamic var isImportant = false
    @objc dynamic var isAddToMyDay = true
    @objc dynamic var txtNote = ""
    
    convenience init(taskName: String, taskScheduledDate: String, taskDueDate: String, isComplete: Bool, isImportant: Bool, isAddToMyDay: Bool, txtNote: String) {
        self.init()
        self.taskWorkName = taskName
        self.taskScheduledDate = taskScheduledDate
        self.taskDueDate = taskDueDate
        self.isComplete = isComplete
        self.isImportant = isImportant
        self.isAddToMyDay = isAddToMyDay
        self.txtNote = txtNote
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? RLMReminder {
            return self.id == obj.id
        }
        return false
    }
}
