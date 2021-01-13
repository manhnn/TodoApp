//
//  MyDayAddViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 02/01/2021.
//

import UIKit
import RealmSwift

protocol MyDayAddViewControllerDelegate {
    func myDayAddViewControllerWillReloadData(_ view: MyDayAddViewController)
}

class MyDayAddViewController: UIViewController {
    // MARK: - UI
    @IBOutlet weak var txtWork: UITextField!
    @IBOutlet weak var txtDateTime: UITextField!
    
    var newReminder = Reminder(taskName: "", taskDateTime: "", isSuccess: false, isImportant: false)
    var delegate: MyDayAddViewControllerDelegate?
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Buttons Action
    @IBAction func btnSaveAction(_ sender: Any) {
        newReminder.taskWorkName = txtWork.text!
        newReminder.taskDateTime = txtDateTime.text!
        if  newReminder.taskWorkName.count == 0 || newReminder.taskDateTime.count == 0 {
            let alertController = UIAlertController(title: "Warning", message: "Please set full information", preferredStyle: .alert)
            let okAcntion = UIAlertAction(title: "OK", style: .default){(action) in }
            alertController.addAction(okAcntion)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            realm.beginWrite()
            realm.add(newReminder)
            try! realm.commitWrite()
        
            navigationController?.popViewController(animated: true)
            self.delegate?.myDayAddViewControllerWillReloadData(self)
        }
    }
}
