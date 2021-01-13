//
//  ImportantAddView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 10/01/2021.
//

import UIKit

protocol ImportantAddViewDelegate {
    func importantAddView(_ view: ImportantAddView, didAddItemSuccessWith reminder: Reminder)
    func importantAddViewDidAddItemFail(_ view: ImportantAddView)
    func importantAddViewDidTapDoneButtonOnKeyboard(_ view: ImportantAddView)
}

class ImportantAddView: UIView, UITextFieldDelegate {
    
    // MARK: - UI
    @IBOutlet weak var txtTaskWork: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDueDateButton: UIButton!
    
    var newReminder = Reminder(id: "", taskName: "", taskScheduledDate: Date(), taskDueDate: Date(timeIntervalSince1970: 0), isComplete: false, isImportant: true, isAddToMyDay: true, txtNote: "Add notes...")
    public var delegate: ImportantAddViewDelegate?

    // MARK: - Buttons Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtTaskWork.resignFirstResponder()
        print("return?")
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
            
            self.delegate?.importantAddView(self, didAddItemSuccessWith: newReminder)
        }
        else {
            self.delegate?.importantAddViewDidAddItemFail(self)
        }
        txtTaskWork.text = ""
        datePicker.isHidden = true
        setDueDateButton.isHidden = false
        self.txtTaskWork.endEditing(true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        delegate?.importantAddViewDidTapDoneButtonOnKeyboard(self)
        self.txtTaskWork.resignFirstResponder()
    }
}


