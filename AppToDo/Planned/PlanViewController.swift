//
//  PlanViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 12/01/2021.
//

import UIKit

class PlanViewController: UIViewController {
    
    // MARK: - Realm
    var listReminder = ReminderStore.SharedInstance.getListReminderHaveDueDate()
    
    var listPlan = [Reminder]()
    var heightKeyboard: CGFloat?
    
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
        // MARK: - Notification
        NotificationCenter.default.addObserver( self, selector: #selector(getKeyboardHeightWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: Get Height keyboard
    @objc func getKeyboardHeightWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            heightKeyboard = keyboardHeight
        }
    }
    
    // MARK: - Show AddView.xib
    func showSubViewXib() {
        let nib = UINib(nibName: "PlanSubViewAdd", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! PlanAddView
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
        let nib = UINib(nibName: "PlanSubMenuView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! PlanMenuView
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
        for obj in listReminder {
            if !obj.taskDueDate.isEmpty {
                listPlan.append(obj)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Custom TableView
extension PlanViewController: UITableViewDataSource {
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPlan") as! PlanTableViewCell
        cell.delegate = self
        cell.reminder = listPlan[indexPath.row]
        cell.setupData(listPlan[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let planDetailViewController = storyboard.instantiateViewController(withIdentifier: "PlanDetailViewController") as! PlanDetailViewController
        planDetailViewController.delegate = self
        planDetailViewController.reminder = listPlan[indexPath.row]
        self.navigationController?.pushViewController(planDetailViewController, animated: true)
    }
}

extension PlanViewController: UITableViewDelegate, UITextFieldDelegate {
    // MARK: - Buttons Action
    @IBAction func btnDidTapShowAddView(_ sender: Any) {
        subViewAddXib.isHidden = false
        btnHiddenSubView.isHidden = true
        showSubViewXib()
        
        self.viewBottomConstraint.constant = -heightKeyboard!
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - Show Menu Sort
    @IBAction func btnDidTapShowMenuSort(_ sender: Any) {
        showSubMenuViewXib()
        subMenuViewXib.isHidden = !subMenuViewXib.isHidden
    }

    // MARK: - Edit Delete Button
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let reminder = listPlan[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action, indexPath in
            self.deleteAction(reminder: reminder, indexPath: indexPath)
        }
        deleteAction.backgroundColor = .systemGray5
        return [deleteAction]
    }
    
    private func deleteAction(reminder: Reminder, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            if let index = listPlan.firstIndex(where: {$0.id == reminder.id}) {
                listPlan.remove(at: index)
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

extension PlanViewController: PlanDetailViewControllerDelegate {
    // MARK: - Delete Reminder
    func planDetailViewController(_ view: PlanDetailViewController, didTapDeleteButtonOn reminder: Reminder) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            tableView.reloadData()
            if let index = listPlan.firstIndex(where: {$0.id == reminder.id}) {
                listPlan.remove(at: index)
                tableView.reloadData()
            }
            
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Change Icon Button Important
    func planDetailViewController(_ view: PlanDetailViewController, didTapImportantButtonOn reminder: Reminder) {
        reminder.isImportant = !reminder.isImportant
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
    }
    
    // MARK: - Click to  Icon Button Complete
    func planDetailViewController(_ view: PlanDetailViewController, didTapCompleteButtonOn reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = listPlan.firstIndex(where: {$0.id == reminder.id}) {
            listPlan.remove(at: index)
            tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Change Icon Button AddToMyDay
    func planDetailViewController(_ view: PlanDetailViewController, didTapAddToMyDayButtonOn reminder: Reminder) {
        reminder.isAddToMyDay = !reminder.isAddToMyDay
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
    }
}

// MARK: - Extension ImportantTableViewCell
extension PlanViewController: PlanTableViewCellDelegate {
    func planTableViewCell(_ view: PlanTableViewCell, didTapCompleteButtonWith reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = listPlan.firstIndex(where: {$0.id == reminder.id}) {
            listPlan.remove(at: index)
            tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
        }
    }
    
    func planTableViewCell(_ view: PlanTableViewCell, didTapImportantButtonWith reminder: Reminder) {
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
    }
}

// MARK: - Extension ImportantAddView Reload Data
extension PlanViewController: PlanAddViewDelegate {
    func planAddView(_ view: PlanAddView, didAddItemSuccessWith reminder: Reminder) {
        listPlan.insert(reminder, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .middle)
        tableView.endUpdates()
        
        self.viewBottomConstraint.constant = 0.0
        UIView.animate(withDuration: 0.75, animations: {
            self.view.layoutIfNeeded()
        })
        
        subViewAddXib.isHidden = true
        btnHiddenSubView.isHidden = false
    }
    
    func planAddViewDidAddItemFail(_ view: PlanAddView) {
        let alert = UIAlertController(title: "Warning", message: "Please set full information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PlanViewController: PlanMenuViewDelegate {
    func planMenuViewDidTapSortByNameButton(_ view: PlanMenuView) {
        let listSortDataByName = ReminderStore.SharedInstance.getListReminderSortByName()
        listPlan.removeAll()
        tableView.reloadData()
        
        var numberRow = 0
        for index in 0...listSortDataByName.count - 1 {
            if !listSortDataByName[index].taskDueDate.isEmpty && !listSortDataByName[index].isComplete{
                listPlan.append(listSortDataByName[index])
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath.init(row: numberRow, section: 0)], with: .left)
                numberRow += 1
                tableView.endUpdates()
            }
        }
        subMenuViewXib.isHidden = true
    }
    
    func planMenuViewDidTapSortByDateTimeButton(_ view: PlanMenuView) {
        let listSortDataByDateTime = ReminderStore.SharedInstance.getListReminderSortByDateTime()
        listPlan.removeAll()
        tableView.reloadData()
        
        var numberRow = 0
        for index in 0...listSortDataByDateTime.count - 1 {
            if !listSortDataByDateTime[index].taskDueDate.isEmpty && !listSortDataByDateTime[index].isComplete{
                listPlan.append(listSortDataByDateTime[index])
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath.init(row: numberRow, section: 0)], with: .left)
                numberRow += 1
                tableView.endUpdates()
            }
        }
        subMenuViewXib.isHidden = true
    }
    
    func planMenuViewDidTapSortByImportantButton(_ view: PlanMenuView) {
        let listSortDataByImportant = ReminderStore.SharedInstance.getListReminderSortByImportant()
        listPlan.removeAll()
        tableView.reloadData()
        
        var numberRow = 0
        for index in 0...listSortDataByImportant.count - 1 {
            if !listSortDataByImportant[index].taskDueDate.isEmpty && !listSortDataByImportant[index].isComplete{
                listPlan.append(listSortDataByImportant[index])
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath.init(row: numberRow, section: 0)], with: .left)
                numberRow += 1
                tableView.endUpdates()
            }
        }
        subMenuViewXib.isHidden = true
    }
}
