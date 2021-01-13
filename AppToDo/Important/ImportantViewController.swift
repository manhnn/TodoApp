//
//  ImportantViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 09/01/2021.
//

import UIKit

class ImportantViewController: UIViewController {
    
    // MARK: - Realm
    var listReminder = ReminderStore.SharedInstance.getListReminderOnlyImportantOption()
    
    var listImportant = [Reminder]()
    
    // MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subMenuViewXib: UIView!
    @IBOutlet weak var subViewAddXib: UIView!
    @IBOutlet weak var btnHiddenSubView: UIButton!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        addDataToListImportant()
    }
    // MARK: - Show AddView.xib
    func showSubViewXib() {
        let nib = UINib(nibName: "ImportantSubViewAdd", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! ImportantAddView
        view.frame = subViewAddXib.bounds
        subViewAddXib.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: subViewAddXib.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: subViewAddXib.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: subViewAddXib.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: subViewAddXib.trailingAnchor).isActive = true
        view.delegate = self
        view.txtTaskWork.delegate = self
        view.txtTaskWork.becomeFirstResponder()
    }
    
    // MARK: - Show MenuView.xib
    func showSubMenuViewXib() {
        let nib = UINib(nibName: "ImportantSubMenuView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! ImportantMenuView
        view.frame = subMenuViewXib.bounds
        subMenuViewXib.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: subMenuViewXib.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: subMenuViewXib.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: subMenuViewXib.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: subMenuViewXib.trailingAnchor).isActive = true
        view.delegate = self
    }
    
    func addDataToListImportant() {
        for index in 0..<listReminder.count {
            listImportant.append(listReminder[index])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Custom TableView
extension ImportantViewController: UITableViewDataSource {
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listImportant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellImportant") as! ImportantTableViewCell
        cell.delegate = self
        cell.reminder = listImportant[indexPath.row]
        cell.setupData(listImportant[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let importantDetailViewController = storyboard.instantiateViewController(withIdentifier: "ImportantDetailViewController") as! ImportantDetailViewController
        
        importantDetailViewController.delegate = self
        importantDetailViewController.reminder = listImportant[indexPath.row]
        self.navigationController?.pushViewController(importantDetailViewController, animated: true)
    }
}

extension ImportantViewController: UITableViewDelegate, UITextFieldDelegate {
    // MARK: - Buttons Action
    @IBAction func btnDidTapShowAddView(_ sender: Any) {
        subViewAddXib.isHidden = false
        btnHiddenSubView.isHidden = true
        showSubViewXib()
        
        self.viewBottomConstraint.constant = -215.0
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - Show Menu Sort
    @IBAction func btnDidTapShowMenuSort(_ sender: Any) {
        subMenuViewXib.isHidden = !subMenuViewXib.isHidden
        showSubMenuViewXib()
    }

    // MARK: - Edit Delete Button
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let reminder = listImportant[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action, indexPath in
            self.deleteAction(reminder: reminder, indexPath: indexPath)
        }
        deleteAction.backgroundColor = .systemGray5
        return [deleteAction]
    }
    
    private func deleteAction(reminder: Reminder, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            if let index = listImportant.firstIndex(where: {$0.id == reminder.id}) {
                listImportant.remove(at: index)
                tableView.reloadData()
            }
            ReminderStore.SharedInstance.removeReminder(reminder: reminder)
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ImportantViewController: ImportantDetailViewControllerDelegate {
    // MARK: - Delete Reminder
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapDeleteButtonOn reminder: Reminder) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            tableView.reloadData()
            if let index = listImportant.firstIndex(where: {$0.id == reminder.id}) {
                listImportant.remove(at: index)
                tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Change Icon Button Important
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapImportantButtonOn reminder: Reminder) {
        reminder.isImportant = !reminder.isImportant
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = listImportant.firstIndex(where: {$0.id == reminder.id}) {
            listImportant.remove(at: index)
            tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Click to  Icon Button Complete
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapCompleteButtonOn reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = listImportant.firstIndex(where: {$0.id == reminder.id}) {
            listImportant.remove(at: index)
            tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Change Icon Button AddToMyDay
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapAddToMyDayButtonOn reminder: Reminder) {
        reminder.isAddToMyDay = !reminder.isAddToMyDay
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
    }
}

// MARK: - Extension ImportantTableViewCell
extension ImportantViewController: ImportantTableViewCellDelegate {
    func importantTableViewCell(_ view: ImportantTableViewCell, didTapCompleteButtonWith reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = listImportant.firstIndex(where: {$0.id == reminder.id}) {
            listImportant.remove(at: index)
            tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
        }
    }
    
    func importantTableViewCell(_ view: ImportantTableViewCell, didTapImportantButtonWith reminder: Reminder) {
        reminder.isImportant = !reminder.isImportant
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = listImportant.firstIndex(where: {$0.id == reminder.id}) {
            listImportant.remove(at: index)
            tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .top)
        }
    }
}

// MARK: - Extension ImportantAddView Reload Data
extension ImportantViewController: ImportantAddViewDelegate {
    func importantAddView(_ view: ImportantAddView, didAddItemSuccessWith reminder: Reminder) {
        listImportant.insert(reminder, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .middle)
        tableView.endUpdates()
        
        self.viewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.75, animations: {
            self.view.layoutIfNeeded()
        })
        
        subViewAddXib.isHidden = true
        btnHiddenSubView.isHidden = false
    }
    
    func importantAddViewDidAddItemFail(_ view: ImportantAddView) {
        let alert = UIAlertController(title: "Warning", message: "Please set full information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ImportantViewController: ImportantMenuViewDelegate {
    func importantMenuViewDidTapSortByNameButton(_ view: ImportantMenuView) {
        let listSortDataByName = ReminderStore.SharedInstance.getListReminderSortByName()
        listImportant.removeAll()
        tableView.reloadData()
        
        for index in 0...listSortDataByName.count - 1 {
            listImportant.append(listSortDataByName[index])
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
            tableView.endUpdates()
        }
        subMenuViewXib.isHidden = true
    }
    
    func importantMenuViewDidTapSortByDateTimeButton(_ view: ImportantMenuView) {
        let listSortDataByDateTime = ReminderStore.SharedInstance.getListReminderSortByDateTime()
        listImportant.removeAll()
        tableView.reloadData()
        
        for index in 0...listSortDataByDateTime.count - 1 {
            listImportant.append(listSortDataByDateTime[index])
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: index, section: 0)], with: .right)
            tableView.endUpdates()
        }
        subMenuViewXib.isHidden = true
    }
}

