//
//  MyDayAddView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 06/01/2021.
//

import UIKit

protocol MyDayAddViewDelegate {
    func myDayAddView(_ view: MyDayAddView, didAddItemSuccessWith reminder: Reminder)
    func myDayAddViewDidAddItemFail(_ view: MyDayAddView)
    func myDayAddViewDidTapDoneButtonOnKeyboard(_ view: MyDayAddView)
}

class MyDayAddView: UIView, UITextFieldDelegate {
    
    // MARK: - UI
    @IBOutlet weak var txtTaskWork: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDueDateButton: UIButton!
    
    var newReminder = Reminder(id: "", taskName: "", taskScheduledDate: Date(), taskDueDate: Date(timeIntervalSince1970: 0), isComplete: false, isImportant: false, isAddToMyDay: true, txtNote: "Add notes...")
    public var delegate: MyDayAddViewDelegate?

    // MARK: - Buttons Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtTaskWork.resignFirstResponder()
        return true
    }
    
    override func awakeFromNib() {
        //print("load")
    }
    
    @IBAction func setDueDateButtonAction(_ sender: Any) {
        setDueDateButton.isHidden = true
        datePicker.isHidden = false
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        newReminder.taskDueDate = datePicker.date
    }
    
    @IBAction func btnDidTapAddReminder(_ sender: Any) {
        txtTaskWork.delegate = self
        newReminder.taskWorkName = txtTaskWork.text!
        newReminder.taskScheduledDate = Date()
        if setDueDateButton.isHidden && !datePicker.isHidden {
            newReminder.taskDueDate = datePicker.date
        }
        
        if  newReminder.taskWorkName != "" {
            ReminderStore.SharedInstance.addReminder(newReminder: newReminder)
            self.delegate?.myDayAddView(self, didAddItemSuccessWith: newReminder)
        }
        else {
            self.delegate?.myDayAddViewDidAddItemFail(self)
        }
        
        txtTaskWork.text = ""
        setDueDateButton.isHidden = false
        datePicker.isHidden = true
        self.txtTaskWork.endEditing(true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        delegate?.myDayAddViewDidTapDoneButtonOnKeyboard(self)
        self.txtTaskWork.resignFirstResponder()
    }
}
