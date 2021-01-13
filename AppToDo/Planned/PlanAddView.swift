//
//  PlanAddView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 12/01/2021.
//

import UIKit

protocol PlanAddViewDelegate {
    func planAddView(_ view: PlanAddView, didAddItemSuccessWith reminder: Reminder)
    func planAddViewDidAddItemFail(_ view: PlanAddView)
}

class PlanAddView: UIView, UITextFieldDelegate {
    
    // MARK: - UI
    @IBOutlet weak var txtTaskWork: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDueDateButton: UIButton!
    
    var newReminder = Reminder(id: "", taskName: "", taskScheduledDate: "", taskDueDate: "", isComplete: false, isImportant: true, isAddToMyDay: true, txtNote: "Add notes...")
    public var delegate: PlanAddViewDelegate?
    
    // MARK: - Buttons Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtTaskWork.resignFirstResponder()
        return true
    }
    
    @IBAction func setDueDateButtonAction(_ sender: Any) {
        datePicker.isHidden = false
        setDueDateButton.isHidden = true
    }
    
    @IBAction func btnDidTapAddReminder(_ sender: Any) {
        //add du lieu vao DB
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        newReminder.taskDueDate = formatter.string(from: datePicker.date)
        
        txtTaskWork.delegate = self
        newReminder.taskWorkName = txtTaskWork.text!
        newReminder.taskScheduledDate = getDateNow()
        if  newReminder.taskWorkName != "" {
            ReminderStore.SharedInstance.addReminder(newReminder: newReminder)
            
            self.delegate?.planAddView(self, didAddItemSuccessWith: newReminder)
        }
        else {
            self.delegate?.planAddViewDidAddItemFail(self)
        }
        txtTaskWork.text = ""
        datePicker.isHidden = true
        setDueDateButton.isHidden = false
        self.txtTaskWork.endEditing(true)
    }
    
    func getDateNow() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }
}

