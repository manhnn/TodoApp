//
//  ImportantDetailViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 10/01/2021.
//

import RealmSwift
import UIKit

protocol ImportantDetailViewControllerDelegate {
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapCompleteButtonOn reminder: Reminder)
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapImportantButtonOn reminder: Reminder)
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapDeleteButtonOn reminder: Reminder)
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapAddToMyDayButtonOn reminder: Reminder)
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapSaveButtonWith reminder: Reminder)
}

class ImportantDetailViewController: UIViewController {
    // MARK: - UI
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnAddToMyDay: UIButton!
    @IBOutlet weak var btnDueDate: UIButton!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let realm = try! Realm()
    
    // MARK: - Property
    var delegate: ImportantDetailViewControllerDelegate?
    var reminder: Reminder!
    
    // MARK: - Detail Reminder
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblWork.text = reminder.taskWorkName
        if reminder.taskDueDate != Date(timeIntervalSince1970: 0) {
            self.btnDueDate.setTitle("Due Date: \(convertDateToString(date: reminder.taskDueDate))", for: .normal)
        }
        else {
            btnDueDate.setTitle("Due Date:", for: .normal)
        }
        setColorForDueDateButton()
        
        if reminder.isComplete {
            btnComplete.setImage(UIImage(named: "checkred"), for: .normal)
        }
        else {
            btnComplete.setImage(UIImage(named: "recred"), for: .normal)
        }
        
        if reminder.isImportant {
            btnImportant.setImage(UIImage(named: "starredd"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starred"), for: .normal)
        }
        
        if reminder.isAddToMyDay {
            btnAddToMyDay.setTitleColor(.systemRed, for: .normal)
        }
        else {
            btnAddToMyDay.setTitleColor(.black, for: .normal)
        }
        
        txtNote.text = reminder.txtNote
    }
    
    // MARK: - Function set color
    func setColorForDueDateButton() {
        if reminder.taskDueDate == Date(timeIntervalSince1970: 0) {
            btnDueDate.setTitleColor(.systemBlue, for: .normal)
        }
        else if reminder.taskDueDate < Date() {
            btnDueDate.setTitleColor(.systemRed, for: .normal)
        }
        else if reminder.taskDueDate > Date() {
            btnDueDate.setTitleColor(.black, for: .normal)
        }
        else {
            btnDueDate.setTitleColor(.systemBlue, for: .normal)
        }
    }
    
    // MARK: - Convert Date to string
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - Buttons Action
    @IBAction func btnCompleteAction(_ sender: Any) {
        delegate?.importantDetailViewController(self, didTapCompleteButtonOn: reminder)
        
        if reminder.isComplete {
            btnComplete.setImage(UIImage(named: "checkred"), for: .normal)
        }
        else {
            btnComplete.setImage(UIImage(named: "recred"), for: .normal)
        }
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        delegate?.importantDetailViewController(self, didTapImportantButtonOn: reminder)
        
        if reminder.isImportant {
            btnImportant.setImage(UIImage(named: "starredd"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starred"), for: .normal)
        }
    }
    
    @IBAction func btnAddToMyDayAction(_ sender: Any) {
        delegate?.importantDetailViewController(self, didTapAddToMyDayButtonOn: reminder)
        
        if reminder.isAddToMyDay {
            btnAddToMyDay.setTitleColor(.systemRed, for: .normal)
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
                }
                ReminderStore.SharedInstance.updateReminder(reminder: reminder)
                delegate?.importantDetailViewController(self, didTapSaveButtonWith: reminder)
                
                btnDueDate.setTitle(convertDateToString(date: reminder.taskDueDate), for: .normal)
                setColorForDueDateButton()
                
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
        
        self.txtNote.endEditing(true)
    }
    
    @IBAction func btnDueDate(_ sender: Any) {
        btnDueDate.setTitleColor(.black, for: .normal)
        datePicker.isHidden = false
    }
     
    @IBAction func btnDeleteReminder(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.importantDetailViewController(self, didTapDeleteButtonOn: reminder)
    }
}

