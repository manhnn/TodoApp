//
//  MyDayViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 01/01/2021.
//

import UIKit

class MyDayViewController: UIViewController {
    
    // MARK: - Get list Reminder from RealmSwift
    var listReminder = ReminderStore.SharedInstance.getListReminder()
    
    // MARK: 2 List show 2 sections
    var listComplete = [Reminder]()
    var listUncomplete = [Reminder]()
    
    // MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subViewAddReminder: UIView!
    @IBOutlet weak var subMenuView: UIView!
    @IBOutlet weak var btnHiddenSubView: UIButton!
    @IBOutlet weak var lblDateNow: UILabel!
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        divDataToTwoList()
    }

    // MARK: - Show AddView xib
    func showViewXib() {
        let nib = UINib(nibName: "MyDaySubViewAdd", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! MyDayAddView
        view.frame = subViewAddReminder.bounds
        subViewAddReminder.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: subViewAddReminder.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: subViewAddReminder.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: subViewAddReminder.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: subViewAddReminder.trailingAnchor).isActive = true
        view.delegate = self
        view.txtTaskWork.delegate = self
        view.txtTaskWork.becomeFirstResponder()
    }
    
    // MARK: - Show MenuView.xib
    func showSubMenuViewXib() {
        let nib = UINib(nibName: "MyDaySubMenuView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! MyDaySubMenuView
        view.frame = subMenuView.bounds
        subMenuView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: subMenuView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: subMenuView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: subMenuView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: subMenuView.trailingAnchor).isActive = true
        view.delegate = self
    }
    
    // MARK: - Select reminder from list add to 2 list where in my day
    func divDataToTwoList() {
        let dayNow = getDateNow()
        for index in 0..<listReminder.count {
            if listReminder[index].isComplete == true && listReminder[index].isAddToMyDay && (compareTwoString(date: dayNow, dateTime: listReminder[index].taskScheduledDate) || compareTwoString(date: dayNow, dateTime: listReminder[index].taskDueDate)) {
                listComplete.append(listReminder[index])
            }
            else if listReminder[index].isComplete == false && listReminder[index].isAddToMyDay && (compareTwoString(date: dayNow, dateTime: listReminder[index].taskScheduledDate) || compareTwoString(date: dayNow, dateTime: listReminder[index].taskDueDate)) {
                listUncomplete.append(listReminder[index])
            }
        }
    }
    
    // MARK: - Get now a today
    func getDateNow() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }
    
    //MARK: - Compare date to dateTime
    func compareTwoString(date: String, dateTime: String) -> Bool {
        if date.count == 0 || dateTime.count == 0 {
            return false
        }
        let subDateTime = dateTime[dateTime.startIndex..<dateTime.index(dateTime.startIndex, offsetBy: date.count)]
        if date == subDateTime {
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - Set DateTime now
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        lblDateNow.text = formatter.string(from: currentDateTime)
    }
}

// MARK: - Custom TableView
extension MyDayViewController: UITableViewDataSource {
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionsType.complete.rawValue {
            return listComplete.count
        }
        return listUncomplete.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMyDay") as! MyDayTableViewCell
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
        let myDayDetailViewController = storyboard.instantiateViewController(withIdentifier: "MyDayDetailViewController") as! MyDayDetailViewController
        
        myDayDetailViewController.delegate = self
        if indexPath.section == SectionsType.complete.rawValue {
            myDayDetailViewController.reminder = listComplete[indexPath.row]
        }
        else {
            myDayDetailViewController.reminder = listUncomplete[indexPath.row]
        }
        self.navigationController?.pushViewController(myDayDetailViewController, animated: true)
    }
    
    // MARK: - Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: -2, width: tableView.frame.width, height: 40))
        view.backgroundColor = .init(red: 191, green: 254, blue: 255, alpha: 0) // BFFEFF
        let lbl = UILabel(frame: CGRect(x: 20, y: -2, width: tableView.frame.width - 20, height: 40))
        lbl.text = (section == SectionsType.nonecomplete.rawValue) ? "" : "🟢 Complete"
        view.addSubview(lbl)
        view.layer.cornerRadius = view.frame.height / 5
        return view
    }
}
extension MyDayViewController: UITableViewDelegate, UITextFieldDelegate {
    // MARK: - Buttons Action
    @IBAction func btnDidTapShowAddView(_ sender: Any) {
        subViewAddReminder.isHidden = false
        btnHiddenSubView.isHidden = true
        showViewXib()
        
        self.viewBottomConstraint.constant = -215.0
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnDidTapShowSubMenuView(_ sender: Any) {
        subMenuView.isHidden = !subMenuView.isHidden
        showSubMenuViewXib()
    }

    // MARK: - Edit Delete Button
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let reminder = indexPath.section == SectionsType.complete.rawValue ? listComplete[indexPath.row] : listUncomplete[indexPath.row]
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

extension MyDayViewController: MyDayDetailViewControllerDelegate {
    // MARK: - Add to MyDay
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapAddToMyDayButtonWith reminder: Reminder) {
        ReminderStore.SharedInstance.removeReminder(reminder: reminder)
        tableView.reloadData()
    }
    
    // MARK: - Delete Reminder
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapDeleteButtonWith reminder: Reminder) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            if !reminder.isComplete {
                if let index = listUncomplete.firstIndex(where: {$0.id == reminder.id} ) {
                    listUncomplete.remove(at: index)
                }
            }
            else {
                if let index = listComplete.firstIndex(where: {$0.id == reminder.id}) {
                    listComplete.remove(at: index)
                }
            }
            
            self.navigationController?.popViewController(animated: true)
    
            ReminderStore.SharedInstance.removeReminder(reminder: reminder)
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Change Icon Button Important
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapImportantButtonWith reminder: Reminder) {
        // Update icon ko can reload data
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            listUncomplete[index].isImportant = !listUncomplete[index].isImportant
            ReminderStore.SharedInstance.updateReminder(reminder: listUncomplete[index])
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? MyDayTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "star"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
        else if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            listComplete[index].isImportant = !listComplete[index].isImportant
            ReminderStore.SharedInstance.updateReminder(reminder: listComplete[index])
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? MyDayTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "star"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
    }
    
    // MARK: - Change Icon Button Success
    func myDayDetailViewController(_ view: MyDayDetailViewController, didTapCompleteButtonWith reminder: Reminder) {
        
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            listUncomplete[index].isComplete = !listUncomplete[index].isComplete
            ReminderStore.SharedInstance.updateReminder(reminder: listUncomplete[index])
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? MyDayTableViewCell {
                if !reminder.isComplete {
                    cell.btnComplete.setImage(UIImage(named: "check"), for: .normal)
                    listComplete.remove(at: index)
                    listUncomplete.append(reminder)
                    tableView.reloadData()
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "rec"), for: .normal)
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
                    cell.btnComplete.setImage(UIImage(named: "check"), for: .normal)
                    listComplete.remove(at: index)
                    listUncomplete.append(reminder)
                    tableView.reloadData()
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "rec"), for: .normal)
                    listUncomplete.remove(at: index)
                    listComplete.append(reminder)
                    tableView.reloadData()
                }
            }
        }
    }
}
// MARK: - Extension MyDayTablewViewCell
extension MyDayViewController: MyDayTableViewCellDelegate {
    func myDayTableViewCell(_ view: MyDayTableViewCell, didTapImportantButtonWith reminder: Reminder) {
        reminder.isImportant = !reminder.isImportant
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        // Update icon ko can reload data
        if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}){
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? MyDayTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "star"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
        
        else if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? MyDayTableViewCell {
                if reminder.isImportant {
                    cell.btnImportant.setImage(UIImage(named: "star"), for: .normal)
                }
                else {
                    cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
                }
            }
        }
    }
    
    func myDayTableViewCell(_ view: MyDayTableViewCell, didTapCompleteButtonWith reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        // Update icon ko can fai reload data
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? MyDayTableViewCell{
                if reminder.isComplete {
                    cell.btnComplete.setImage(UIImage(named: "check"), for: .normal)
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "rec"), for: .normal)
                }
            }
        }
       
        if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? MyDayTableViewCell{
                if reminder.isComplete {
                    cell.btnComplete.setImage(UIImage(named: "check"), for: .normal)
                }
                else {
                    cell.btnComplete.setImage(UIImage(named: "rec"), for: .normal)
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

// MARK: - Extension MyDayAddView Reload Data
extension MyDayViewController: MyDayAddViewDelegate {
    func myDayAddView(_ view: MyDayAddView, didAddItemSuccessWith reminder: Reminder) {
        listUncomplete.insert(reminder, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .middle)
        tableView.endUpdates()
        
        self.viewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.75, animations: {
            self.view.layoutIfNeeded()
        })
        
        subViewAddReminder.isHidden = true
        btnHiddenSubView.isHidden = false
    }
    
    func myDayAddViewDidAddItemFail(_ view: MyDayAddView) {
        let alert = UIAlertController(title: "Warning", message: "Please set full information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extension MyDaySubMenuView when Sorting
extension MyDayViewController: MyDaySubMenuViewDelegate {
    func myDaySubMenuViewDidTapSortByNameButton(_ view: MyDaySubMenuView) {
        let dayNow = getDateNow()
        let listSortDataByName = ReminderStore.SharedInstance.getListReminderSortByName()
        listComplete.removeAll()
        listUncomplete.removeAll()
        for index in 0...listSortDataByName.count - 1  {
            if listSortDataByName[index].isComplete == true && listSortDataByName[index].isAddToMyDay && compareTwoString(date: dayNow, dateTime: listSortDataByName[index].taskScheduledDate) {
                listComplete.append(listSortDataByName[index])
            }
            else if listSortDataByName[index].isComplete == false && listSortDataByName[index].isAddToMyDay && compareTwoString(date: dayNow, dateTime: listSortDataByName[index].taskScheduledDate) {
                listUncomplete.append(listSortDataByName[index])
            }
        }
        subMenuView.isHidden = true
        tableView.reloadData()
    }
    
    func myDaySubMenuViewDidTapSortByDateTimeButton(_ view: MyDaySubMenuView) {
        let dayNow = getDateNow()
        let listSortDataByDateTime = ReminderStore.SharedInstance.getListReminderSortByDateTime()
        listComplete.removeAll()
        listUncomplete.removeAll()
        for index in 0...listSortDataByDateTime.count - 1  {
            if listSortDataByDateTime[index].isComplete == true && listSortDataByDateTime[index].isAddToMyDay && compareTwoString(date: dayNow, dateTime: listSortDataByDateTime[index].taskDueDate) {
                listComplete.append(listSortDataByDateTime[index])
            }
            else if listSortDataByDateTime[index].isComplete == false && listSortDataByDateTime[index].isAddToMyDay && compareTwoString(date: dayNow, dateTime: listSortDataByDateTime[index].taskScheduledDate) {
                listUncomplete.append(listSortDataByDateTime[index])
            }
        }
        subMenuView.isHidden = true
        tableView.reloadData()
    }
    
    func myDaySubMenuViewDidTapSortByImportantButton(_ view: MyDaySubMenuView) {
        let dayNow = getDateNow()
        let listSortDataByImportant = ReminderStore.SharedInstance.getListReminderSortByImportant()
        listComplete.removeAll()
        listUncomplete.removeAll()
        for index in 0...listSortDataByImportant.count - 1 {
            if listSortDataByImportant[index].isComplete == true && listSortDataByImportant[index].isAddToMyDay && compareTwoString(date: dayNow, dateTime: listSortDataByImportant[index].taskScheduledDate) {
                listComplete.append(listSortDataByImportant[index])
            }
            else if listSortDataByImportant[index].isComplete == false && listSortDataByImportant[index].isAddToMyDay && compareTwoString(date: dayNow, dateTime: listSortDataByImportant[index].taskScheduledDate) {
                listUncomplete.append(listSortDataByImportant[index])
            }
        }
        subMenuView.isHidden = true
        tableView.reloadData()
    }
}
