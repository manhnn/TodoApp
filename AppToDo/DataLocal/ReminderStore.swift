//
//  ReminderStore.swift
//  AppToDo
//
//  Created by Nguyen Manh on 11/01/2021.
//

import Foundation
import RealmSwift

class ReminderStore {
    
    func getListReminder() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self)
        var listReminder = [Reminder]()
        for obj in listResult {
            listReminder.append(Reminder.init(id: obj.id, taskName: obj.taskWorkName, taskScheduledDate: obj.taskScheduledDate, taskDueDate: obj.taskDueDate, isComplete: obj.isComplete, isImportant: obj.isImportant, isAddToMyDay: obj.isAddToMyDay, txtNote: obj.txtNote))
        }
        return listReminder
    }
    
    func getListReminderSortByName() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).sorted(byKeyPath: "taskWorkName", ascending: true)
        var listReminder = [Reminder]()
        for obj in listResult {
            listReminder.append(Reminder.init(id: obj.id, taskName: obj.taskWorkName, taskScheduledDate: obj.taskScheduledDate, taskDueDate: obj.taskDueDate, isComplete: obj.isComplete, isImportant: obj.isImportant, isAddToMyDay: obj.isAddToMyDay, txtNote: obj.txtNote))
        }
        return listReminder
    }
    
    func getListReminderSortByDateTime() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).sorted(byKeyPath: "taskScheduledDate", ascending: true)
        var listReminder = [Reminder]()
        for obj in listResult {
            listReminder.append(Reminder.init(id: obj.id, taskName: obj.taskWorkName, taskScheduledDate: obj.taskScheduledDate, taskDueDate: obj.taskDueDate, isComplete: obj.isComplete, isImportant: obj.isImportant, isAddToMyDay: obj.isAddToMyDay, txtNote: obj.txtNote))
        }
        return listReminder
    }
    
    func getListReminderSortByImportant() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).sorted(byKeyPath: "isImportant", ascending: false)
        var listReminder = [Reminder]()
        for obj in listResult {
            listReminder.append(Reminder.init(id: obj.id, taskName: obj.taskWorkName, taskScheduledDate: obj.taskScheduledDate, taskDueDate: obj.taskDueDate, isComplete: obj.isComplete, isImportant: obj.isImportant, isAddToMyDay: obj.isAddToMyDay, txtNote: obj.txtNote))
        }
        return listReminder
    }
    
    func getListReminderOnlyImportantOption() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).filter("isImportant == true").filter("isComplete == false")
        var listReminder = [Reminder]()
        for obj in listResult {
            listReminder.append(Reminder.init(id: obj.id, taskName: obj.taskWorkName, taskScheduledDate: obj.taskScheduledDate, taskDueDate: obj.taskDueDate, isComplete: obj.isComplete, isImportant: obj.isImportant, isAddToMyDay: obj.isAddToMyDay, txtNote: obj.txtNote))
        }
        return listReminder
    }
    
    func getListReminderHaveDueDate() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).filter("isComplete == false") // filter taskScheduled.isEmpty
        var listReminder = [Reminder]()
        for obj in listResult {
            listReminder.append(Reminder.init(id: obj.id, taskName: obj.taskWorkName, taskScheduledDate: obj.taskScheduledDate, taskDueDate: obj.taskDueDate, isComplete: obj.isComplete, isImportant: obj.isImportant, isAddToMyDay: obj.isAddToMyDay, txtNote: obj.txtNote))
        }
        return listReminder
    }
    
    func addReminder(newReminder: Reminder) {
        let rlmReminder = RLMReminder.init(taskName: newReminder.taskWorkName, taskScheduledDate: newReminder.taskScheduledDate, taskDueDate: newReminder.taskDueDate, isComplete: newReminder.isComplete, isImportant: newReminder.isImportant, isAddToMyDay: newReminder.isAddToMyDay, txtNote: newReminder.txtNote)
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(rlmReminder)
        try! realm.commitWrite()
    }
    
    func updateReminder(reminder: Reminder) {
        let realm = try! Realm()
        let rlmReminderInRealm = realm.objects(RLMReminder.self)
        for obj in rlmReminderInRealm {
            if obj.id == reminder.id {
                try! realm.write {
                    obj.taskWorkName = reminder.taskWorkName
                    obj.taskScheduledDate = reminder.taskScheduledDate
                    obj.taskDueDate = reminder.taskDueDate
                    obj.isComplete = reminder.isComplete
                    obj.isImportant = reminder.isImportant
                    obj.isAddToMyDay = reminder.isAddToMyDay
                    obj.txtNote = reminder.txtNote
                }
                return
            }
        }
    }
    
    func removeReminder(reminder: Reminder) {
        let realm = try! Realm()
        let rlmReminderInRealm = realm.objects(RLMReminder.self)
        for obj in rlmReminderInRealm {
            if obj.id == reminder.id {
                try! realm.write {
                    realm.delete(obj)
                }
                return
            }
        }
    }
    
    //ReminderStore.SharedInstance
    class var SharedInstance: ReminderStore {
        struct Static {
            static let instance = ReminderStore()
        }
        return Static.instance
    }
}
