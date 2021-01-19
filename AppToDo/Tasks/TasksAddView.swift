//
//  TasksAddView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 08/01/2021.
//

import UIKit

protocol TasksAddViewDelegate: class {
    func tasksAddView(_ view: TasksAddView, didAddItemSuccessWith reminder: Reminder)
    func tasksAddViewDidAddItemFail(_ view: TasksAddView)
    func tasksAddViewDidTapDoneButtonOnKeyboard(_ view: TasksAddView)
}

class TasksAddView: UIView, UITextFieldDelegate {
    
    // MARK: - UI
    @IBOutlet weak var txtTaskWork: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDueDateButton: UIButton!
    
    var newReminder = Reminder(id: "", taskName: "", taskScheduledDate: Date(), taskDueDate: Date(timeIntervalSince1970: 0), isComplete: false, isImportant: false, isAddToMyDay: true, txtNote: "Add notes...")
    
    weak var delegate: TasksAddViewDelegate?

    // MARK: - Buttons Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtTaskWork.resignFirstResponder()
        return true
    }
    @IBAction func setDueDateButtonAction(_ sender: Any) {
        datePicker.isHidden = false
        setDueDateButton.isHidden = true
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        newReminder.taskDueDate = datePicker.date
    }
    
    @IBAction func btnDidTapAddReminder(_ sender: Any) {
        //add du lieu vao DB
        txtTaskWork.delegate = self
        newReminder.taskWorkName = txtTaskWork.text!
        newReminder.taskScheduledDate = Date()
        
        if  newReminder.taskWorkName != "" {
            ReminderStore.SharedInstance.addReminder(newReminder: newReminder)
            
            self.delegate?.tasksAddView(self, didAddItemSuccessWith: newReminder)
        }
        else {
            self.delegate?.tasksAddViewDidAddItemFail(self)
        }
        txtTaskWork.text = ""
        datePicker.isHidden = true
        setDueDateButton.isHidden = false
        self.txtTaskWork.endEditing(true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        delegate?.tasksAddViewDidTapDoneButtonOnKeyboard(self)
        self.txtTaskWork.resignFirstResponder()
    }
}

