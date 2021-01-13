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
        self.btnDueDate.setTitle("Due Date: " + reminder.taskDueDate, for: .normal)
        
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
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        
        let alertWarning = UIAlertController(title: "Warning", message: "You don't update anything", preferredStyle: .alert)
        let alertSuccess = UIAlertController(title: "Congratulation!", message: "Update Success", preferredStyle: .alert)
        let alertSave = UIAlertController(title: "Save", message: "Are you sure you want to 'Save reminder'?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            if reminder.txtNote == txtNote.text && reminder.taskDueDate == formatter.string(from: datePicker.date) {
                let iknowAction = UIAlertAction(title: "I undersand!", style: .default, handler: nil)
                alertWarning.addAction(iknowAction)
                present(alertWarning, animated: true)
            }
            else {
                if reminder.txtNote != txtNote.text {
                    reminder.txtNote = txtNote.text
                }
                if datePicker.isHidden == false {
                    reminder.taskDueDate = formatter.string(from: datePicker.date)
                }
                ReminderStore.SharedInstance.updateReminder(reminder: reminder)
            
                
                btnDueDate.setTitle(formatter.string(from: datePicker.date), for: .normal)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
                alertSuccess.addAction(yesAction)
                present(alertSuccess, animated: true)
                
                btnDueDate.setTitleColor(.systemRed, for: .normal)
                datePicker.isHidden = true
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertSave.addAction(deleteAction)
        alertSave.addAction(cancelAction)
        present(alertSave, animated: true)
        
        self.txtNote.endEditing(true)
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        print(formatter.string(from: datePicker.date))
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

