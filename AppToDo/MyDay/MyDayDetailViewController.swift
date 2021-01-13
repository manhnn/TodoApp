//
//  MyDayDetailViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 04/01/2021.
//

import UIKit

protocol MyDayDetailViewControllerDelegate {
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapCompleteButtonWith reminder: Reminder)
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapImportantButtonWith reminder: Reminder)
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapDeleteButtonWith reminder: Reminder)
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapAddToMyDayButtonWith reminder: Reminder)
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapSaveButtonWith reminder: Reminder)
}

class MyDayDetailViewController: UIViewController, UITextViewDelegate {
    // MARK: - UI
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnAddToMyDay: UIButton!
    @IBOutlet weak var btnDueDate: UIButton!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Property
    var delegate: MyDayDetailViewControllerDelegate?
    var reminder: Reminder!
    var heightKeyboard: CGFloat?
    
    // MARK: - Detail Reminder
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblWork.text = reminder.taskWorkName
        if reminder.taskDueDate != Date(timeIntervalSince1970: 0) {
            self.btnDueDate.setTitle("Due Date: \(reminder.taskDueDate.toString())", for: .normal)
        }
        else {
            btnDueDate.setTitle("Due Date:", for: .normal)
        }
        setColorForDueDateButton()
        
        if reminder.isComplete {
            btnComplete.setImage(UIImage(named: "check"), for: .normal)
        }
        else {
            btnComplete.setImage(UIImage(named: "rec"), for: .normal)
        }
        
        if reminder.isImportant {
            btnImportant.setImage(UIImage(named: "star"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starred"), for: .normal)
        }
        
        if reminder.isAddToMyDay {
            btnAddToMyDay.setTitleColor(.systemBlue, for: .normal)
        }
        else {
            btnAddToMyDay.setTitleColor(.black, for: .normal)
        }
        
        txtNote.delegate = self
        txtNote.text = reminder.txtNote
        txtNote.addDoneButtonOnKeyboard()
    }
    
    // MARK: - Function set color
    func setColorForDueDateButton() {
        if reminder.taskDueDate == Date(timeIntervalSince1970: 0) {
            btnDueDate.setTitleColor(.systemBlue, for: .normal)
        }
        else if reminder.taskDueDate > Date() {
            btnDueDate.setTitleColor(.black, for: .normal)
        }
        else if reminder.taskDueDate.getDateOnlyToString() == Date().getDateOnlyToString() {
            btnDueDate.setTitleColor(.systemPurple, for: .normal)
        }
        else {
            btnDueDate.setTitleColor(.systemRed, for: .normal)
        }
    }
    
    // MARK: - Buttons Action
    @IBAction func btnCompleteAction(_ sender: Any) {
        delegate?.myDayDetailViewController(self, didTapCompleteButtonWith: reminder)
        
        if reminder.isComplete {
            btnComplete.setImage(UIImage(named: "check"), for: .normal)
        }
        else {
            btnComplete.setImage(UIImage(named: "rec"), for: .normal)
        }
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        delegate?.myDayDetailViewController(self, didTapImportantButtonWith: reminder)
        
        if reminder.isImportant {
            btnImportant.setImage(UIImage(named: "star"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starred"), for: .normal)
        }
    }
    
    @IBAction func btnAddToMyDayAction(_ sender: Any) {
        delegate?.myDayDetailViewController(self, didTapAddToMyDayButtonWith: reminder)
        
        if reminder.isAddToMyDay {
            btnAddToMyDay.setTitleColor(.systemBlue, for: .normal)
        }
        else {
            btnAddToMyDay.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        let alertWarning = UIAlertController(title: "Warning", message: "You don't update anything", preferredStyle: .alert)
        let alertSuccess = UIAlertController(title: "Congratulation!", message: "Update Success", preferredStyle: .alert)
        let alertSave = UIAlertController(title: "Save", message: "Are you sure you want to 'Save reminder'?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            if reminder.txtNote == txtNote.text && reminder.taskDueDate == datePicker.date {
                let iknowAction = UIAlertAction(title: "I undersand", style: .default, handler: nil)
                alertWarning.addAction(iknowAction)
                present(alertWarning, animated: true)
            }
            else {
                if reminder.txtNote != txtNote.text {
                    reminder.txtNote = txtNote.text
                }
                if datePicker.isHidden == false {
                    reminder.taskDueDate = datePicker.date
                    btnDueDate.setTitle(reminder.taskDueDate.toString(), for: .normal)
                    setColorForDueDateButton()
                }
                ReminderStore.SharedInstance.updateReminder(reminder: reminder)
                delegate?.myDayDetailViewController(self, didTapSaveButtonWith: reminder)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
                alertSuccess.addAction(yesAction)
                present(alertSuccess, animated: true)
                
                datePicker.isHidden = true
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertSave.addAction(deleteAction)
        alertSave.addAction(cancelAction)
        present(alertSave, animated: true)
        
        btnDueDate.setTitleColor(.systemBlue, for: .normal)
        datePicker.isHidden = true
    }
    
    @IBAction func btnDueDate(_ sender: Any) {
        btnDueDate.setTitleColor(.black, for: .normal)
        datePicker.isHidden = false
    }
     
    @IBAction func btnDeleteReminder(_ sender: Any) {
        delegate?.myDayDetailViewController(self, didTapDeleteButtonWith: reminder)
        navigationController?.popViewController(animated: true)
    }
}
