//
//  TasksViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 08/01/2021.
//

import UIKit

class TasksViewController: UIViewController {
    
    // MARK: - Get data from Realm
    var listReminder = ReminderStore.SharedInstance.getListReminder()
    
    // MARK: 2 List show 2 sections
    var listComplete = [Reminder]()
    var listUncomplete = [Reminder]()
    
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
        
        divDataToTwoListTasks()
    }
    
    // MARK: - Show View.xib
    func showSubViewXib() {
        let nib = UINib(nibName: "TasksSubViewAdd", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! TasksAddView
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
        let nib = UINib(nibName: "TasksSubMenuView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! TasksMenuView
        view.frame = subMenuViewXib.bounds
        subMenuViewXib.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: subMenuViewXib.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: subMenuViewXib.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: subMenuViewXib.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: subMenuViewXib.trailingAnchor).isActive = true
        view.delegate = self
    }
    
    // MARK: - Div From listReminder to 2 subList
    func divDataToTwoListTasks() {
        for index in 0..<listReminder.count {
            if listReminder[index].isComplete == true {
                listComplete.append(listReminder[index])
            }
            else if listReminder[index].isComplete == false {
                listUncomplete.append(listReminder[index])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

// MARK: - Custom TableView
extension TasksViewController: UITableViewDataSource {
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionsType.complete.rawValue {
            return listComplete.count
        }
        return listUncomplete.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTasks") as! TasksTableViewCell
        cell.delegate = self
        
        if indexPath.section == SectionsType.nonecomplete.rawValue {
            cell.reminder = listUncomplete[indexPath.row]
        }
        else {
            cell.reminder = listComplete[indexPath.row]
        }
        
        if indexPath.section == SectionsType.complete.rawValue {
            cell.setupData(listComplete[indexPath.row])
            return cell
        }
        if indexPath.section == SectionsType.nonecomplete.rawValue {
            cell.setupData(listUncomplete[indexPath.row])
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tasksDetailViewController = storyboard.instantiateViewController(withIdentifier: "TasksDetailViewController") as! TasksDetailViewController
        
        tasksDetailViewController.delegate = self
        if indexPath.section == SectionsType.complete.rawValue {
            tasksDetailViewController.reminder = listComplete[indexPath.row]
        }
        else {
            tasksDetailViewController.reminder = listUncomplete[indexPath.row]
        }
        self.navigationController?.pushViewController(tasksDetailViewController, animated: true)
    }
    
    // MARK: - Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionsType.nonecomplete.rawValue {
            return "None Complete"
        }
        return "Complete"
    }
}
extension TasksViewController: UITableViewDelegate, UITextFieldDelegate {
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
        showSubMenuViewXib()
        subMenuViewXib.isHidden = !subMenuViewXib.isHidden
    }

    // MARK: - Edit Delete Button
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let reminder = indexPath.section == 0 ? listUncomplete[indexPath.row] : listComplete[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action, indexPath in
            self.deleteAction(reminder: reminder, indexPath: indexPath)
        }
        deleteAction.backgroundColor = .systemGray5
        return [deleteAction]
    }
    
    private func deleteAction(reminder: Reminder, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            if !reminder.isComplete {
                if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
                    listUncomplete.remove(at: index)
                }
            }
            else {
                if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
                    listComplete.remove(at: index)
                }
            }
            
            ReminderStore.SharedInstance.removeReminder(reminder: reminder)
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension TasksViewController: TasksDetailViewControllerDelegate {
    // MARK: - Delete Reminder
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapDeleteButtonWith reminder: Reminder) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            if !reminder.isComplete {
                if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
                    listUncomplete.remove(at: index)
                }
            }
            else {
                if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
                    listComplete.remove(at: index)
                }
            }
            
            ReminderStore.SharedInstance.removeReminder(reminder: reminder)
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Change Icon Button Important
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapImportantButtonWith reminder: Reminder) {
        // Update icon ko can reload data
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            listUncomplete[index].isImportant = !listUncomplete[index].isImportant
            ReminderStore.SharedInstance.updateReminder(reminder: listUncomplete[index])
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? TasksTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
        else if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            listComplete[index].isImportant = !listComplete[index].isImportant
            ReminderStore.SharedInstance.updateReminder(reminder: listComplete[index])
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? TasksTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
    }
    
    // MARK: - Change Icon Button Complete
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapCompleteButtonWith reminder: Reminder) {
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            listUncomplete[index].isComplete = !listUncomplete[index].isComplete
            ReminderStore.SharedInstance.updateReminder(reminder: listUncomplete[index])
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? TasksTableViewCell {
                if !reminder.isComplete {
                    cell.btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
                    listComplete.remove(at: index)
                    listUncomplete.append(reminder)
                    tableView.reloadData()
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
                    listUncomplete.remove(at: index)
                    listComplete.append(reminder)
                    tableView.reloadData()
                }
            }
        } 
        else if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            listComplete[index].isComplete = !listComplete[index].isComplete
            ReminderStore.SharedInstance.updateReminder(reminder: listComplete[index])
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? TasksTableViewCell {
                if !reminder.isComplete {
                    cell.btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
                    listComplete.remove(at: index)
                    listUncomplete.append(reminder)
                    tableView.reloadData()
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
                    listUncomplete.remove(at: index)
                    listComplete.append(reminder)
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Change Icon Button AddToMyDay
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapAddToMyDayButtonWith reminder: Reminder) {
        reminder.isAddToMyDay = !reminder.isAddToMyDay
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        tableView.reloadData()
    }
}

// MARK: - Extension TasksTableViewCell
extension TasksViewController: TasksTableViewCellDelegate {
    func tasksTableViewCell(_ view: TasksTableViewCell, didTapImportantButtonWith reminder: Reminder) {
        reminder.isImportant = !reminder.isImportant
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        // Update icon ko can reload data
        if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}){
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? TasksTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
        
        else if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? TasksTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
    }
    
    func tasksTableViewCell(_ view: TasksTableViewCell, didTapCompleteButtonWith reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        // Update icon ko can fai reload data
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? TasksTableViewCell{
                if reminder.isComplete {
                    cell.btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
                }
            }
        }
       
        if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? TasksTableViewCell{
                if reminder.isComplete {
                    cell.btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
                }
            }
        }
        
        if reminder.isComplete {
            if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
                listUncomplete.remove(at: index)
                listComplete.append(reminder)
            }
        }
        else {
            if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
                listComplete.remove(at: index)
                listUncomplete.append(reminder)
            }
        }
        tableView.reloadData()
    }
}

// MARK: - Extension TasksAddView Reload Data
extension TasksViewController: TasksAddViewDelegate {
    func tasksAddView(_ view: TasksAddView, didAddItemSuccessWith reminder: Reminder) {
        listUncomplete.insert(reminder, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .top)
        tableView.endUpdates()
        
        self.viewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.75, animations: {
            self.view.layoutIfNeeded()
        })
        
        subViewAddXib.isHidden = true
        btnHiddenSubView.isHidden = false
    }
    
    func tasksAddViewDidAddItemFail(_ view: TasksAddView) {
        let alert = UIAlertController(title: "Warning", message: "Please set full information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension TasksViewController: TasksMenuViewDelegate {
    func tasksMenuViewDidTapSortByNameButton(_ view: TasksMenuView) {
        let listSortDataByName = ReminderStore.SharedInstance.getListReminderSortByName()
        listComplete.removeAll()
        listUncomplete.removeAll()
        for index in 0...listSortDataByName.count - 1 {
            if listSortDataByName[index].isComplete == true {
                listComplete.append(listSortDataByName[index])
            }
            else if listSortDataByName[index].isComplete == false {
                listUncomplete.append(listSortDataByName[index])
            }
        }
        subMenuViewXib.isHidden = true
        tableView.reloadData()
    }
    
    func tasksMenuViewDidTapSortByDateTimeButton(_ view: TasksMenuView) {
        let listSortDataByDateTime = ReminderStore.SharedInstance.getListReminderSortByDateTime()
        listComplete.removeAll()
        listUncomplete.removeAll()
        for index in 0...listSortDataByDateTime.count - 1 {
            if listSortDataByDateTime[index].isComplete == true {
                listComplete.append(listSortDataByDateTime[index])
            }
            else if listSortDataByDateTime[index].isComplete == false {
                listUncomplete.append(listSortDataByDateTime[index])
            }
        }
        subMenuViewXib.isHidden = true
        tableView.reloadData()
    }
    
    func tasksMenuViewDidTapSortByImportantButton(_ view: TasksMenuView) {
        let listSortDataByImportant = ReminderStore.SharedInstance.getListReminderSortByImportant()
        listComplete.removeAll()
        listUncomplete.removeAll()
        for index in 0...listSortDataByImportant.count - 1 {
            if listSortDataByImportant[index].isComplete == true {
                listComplete.append(listSortDataByImportant[index])
            }
            else if listSortDataByImportant[index].isComplete == false {
                listUncomplete.append(listSortDataByImportant[index])
            }
        }
        subMenuViewXib.isHidden = true
        tableView.reloadData()
    }
}
