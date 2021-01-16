//
//  TasksDetailViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 08/01/2021.
//

import UIKit

protocol TasksDetailViewControllerDelegate {
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapCompleteButtonWith reminder: Reminder)
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapImportantButtonWith reminder: Reminder)
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapDeleteButtonWith reminder: Reminder)
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapAddToMyDayButtonWith reminder: Reminder)
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapSaveButtonWith reminder: Reminder)
}

class TasksDetailViewController: UIViewController {
    // MARK: - UI
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnAddToMyDay: UIButton!
    @IBOutlet weak var btnDueDate: UIButton!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Property
    var delegate: TasksDetailViewControllerDelegate?
    var reminder: Reminder!
    
    // MARK: - Detail Reminder
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SettingStore.SharedInstance.getBackgroundColor(idViewController: ViewControllerType.tasks.rawValue)
        
        if reminder.isComplete {
            self.lblWork.attributedText = reminder.taskWorkName.strikeThrough()
        }
        else {
            self.lblWork.attributedText = reminder.taskWorkName.unStrikeThrough()
        }
        
        if reminder.taskDueDate != Date(timeIntervalSince1970: 0) {
            self.btnDueDate.setTitle("Due Date: \(reminder.taskDueDate.toString())", for: .normal)
        }
        else {
            btnDueDate.setTitle("Due Date:", for: .normal)
        }
        setColorForDueDateButton()
        
        if reminder.isComplete {
            btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
        }
        else {
            btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
        }
        
        if reminder.isImportant {
            btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
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
        
        txtNote.text = reminder.txtNote
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tapGestureHiddenKeyboard))
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
    @IBAction func btnSuccessAction(_ sender: Any) {
        delegate?.tasksDetailViewController(self, didTapCompleteButtonWith: reminder)
        
        if reminder.isComplete {
            btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
            lblWork.attributedText = reminder.taskWorkName.strikeThrough()
        }
        else {
            btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
            lblWork.attributedText = reminder.taskWorkName.unStrikeThrough()
        }
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        delegate?.tasksDetailViewController(self, didTapImportantButtonWith: reminder)
        
        if reminder.isImportant {
            btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starred"), for: .normal)
        }
    }
    
    @IBAction func btnAddToMyDayAction(_ sender: Any) {
        delegate?.tasksDetailViewController(self, didTapAddToMyDayButtonWith: reminder)
        
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
                let iknowAction = UIAlertAction(title: "I undersand!", style: .default, handler: nil)
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
                delegate?.tasksDetailViewController(self, didTapSaveButtonWith: reminder)
                
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
    }
    
    @IBAction func btnDueDate(_ sender: Any) {
        btnDueDate.setTitleColor(.black, for: .normal)
        datePicker.isHidden = false
    }
    
    @IBAction func btnDeleteReminder(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.tasksDetailViewController(self, didTapDeleteButtonWith: reminder)
    }
    
    @objc func tapGestureHiddenKeyboard() {
        txtNote.resignFirstResponder()
    }
}
