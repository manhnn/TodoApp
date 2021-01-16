//
//  ReminderStore.swift
//  AppToDo
//
//  Created by Nguyen Manh on 11/01/2021.
//

import Foundation
import RealmSwift

class ReminderStore {
    
    // MARK: - Get list reminder by name, date, important ...
    fileprivate func ConvertListRLMReminderToListReminder(_ listResult: Results<RLMReminder>) -> [Reminder] {
        var listReminder = [Reminder]()
        for obj in listResult {
            listReminder.append(Reminder.init(id: obj.id, taskName: obj.taskWorkName, taskScheduledDate: obj.taskScheduledDate, taskDueDate: obj.taskDueDate, isComplete: obj.isComplete, isImportant: obj.isImportant, isAddToMyDay: obj.isAddToMyDay, txtNote: obj.txtNote))
        }
        return listReminder
    }
    
    func getListReminder() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self)
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    func getListReminderSortByName() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).sorted(byKeyPath: "taskWorkName", ascending: true)
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    func getListReminderSortByDateTime() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).sorted(byKeyPath: "taskDueDate", ascending: false)
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    func getListReminderSortByImportant() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).sorted(byKeyPath: "isImportant", ascending: false)
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    func getListReminderOnlyImportantOption() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).filter("isImportant == true").filter("isComplete == false")
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    func getListReminderOnlyImportantOptionSortByName() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).filter("isImportant == true").filter("isComplete == false").sorted(byKeyPath: "taskWorkName", ascending: true)
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    func getListReminderOnlyImportantOptionSortByDate() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).filter("isImportant == true").filter("isComplete == false").sorted(byKeyPath: "taskDueDate", ascending: false)
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    func getListReminderInPlan() -> Array<Reminder> {
        let realm = try! Realm()
        let listResult = realm.objects(RLMReminder.self).filter("isComplete == false") // filter duedate != Date(timeIntervalSince1970: 0)
        return ConvertListRLMReminderToListReminder(listResult)
    }
    
    // MARK: - Function add update delete reminder
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
    
    // MARK: - ReminderStore.SharedInstance
    class var SharedInstance: ReminderStore {
        struct Static {
            static let instance = ReminderStore()
        }
        return Static.instance
    }
}
