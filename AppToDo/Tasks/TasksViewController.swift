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
    var heightKeyboard: CGFloat?
    
    // MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subMenuViewXib: UIView!
    @IBOutlet weak var subViewAddXib: UIView!
    @IBOutlet weak var subColorViewXib: UIView!
    @IBOutlet weak var btnHiddenSubView: UIButton!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SettingStore.SharedInstance.getBackgroundColor(idViewController: ViewControllerType.tasks.rawValue)
        tableView.delegate = self
        tableView.dataSource = self
        
        divDataToTwoListTasks()
        
        NotificationCenter.default.addObserver( self, selector: #selector(getKeyboardHeightWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Get Height keyboard
    @objc func getKeyboardHeightWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            heightKeyboard = keyboardRectangle.height
        }
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
    
    // MARK: - Show SubColorView.xib
    func showColorViewXib() {
        let nib = UINib(nibName: "SubColorView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! SubColorView
        view.frame = subColorViewXib.bounds
        subColorViewXib.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: subColorViewXib.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: subColorViewXib.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: subColorViewXib.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: subColorViewXib.trailingAnchor).isActive = true
        view.delegate = self
    }
    
    // MARK: - Div From listReminder to 2 subList
    func divDataToTwoListTasks() {
        for obj in listReminder {
            if obj.isComplete == true {
                listComplete.append(obj)
            }
            else if obj.isComplete == false {
                listUncomplete.append(obj)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - UITableViewDataSource 
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
        return 80.0
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
        
        UIView.animate(withDuration: 0.4, animations: {
            self.viewBottomConstraint.constant = self.heightKeyboard ?? 315
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Button Show Color View
    @IBAction func btnShowColorView(_ sender: Any) {
        subColorViewXib.isHidden = !subColorViewXib.isHidden
        showColorViewXib()
    }
    
    //MARK: - Show Menu Sort
    @IBAction func btnDidTapShowMenuSort(_ sender: Any) {
        showSubMenuViewXib()
        subMenuViewXib.isHidden = !subMenuViewXib.isHidden
    }

    // MARK: - Edit Delete Button
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let reminder = indexPath.section == 0 ? listUncomplete[indexPath.row] : listComplete[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {action, indexPath in
            self.deleteAction(reminder: reminder, indexPath: indexPath)
        }
        deleteAction.backgroundColor = .systemGray5
        return [deleteAction]
    }
    
    private func deleteAction(reminder: Reminder, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete reminder?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
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
    fileprivate func tasksViewControllerChangeImageButtonImportant(_ index: Array<Reminder>.Index, _ reminder: Reminder, _ section: Int) {
        if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: section)) as? TasksTableViewCell {
            if reminder.isImportant {
                cell.btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
            }
            else {
                cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
            }
        }
    }
    
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapImportantButtonWith reminder: Reminder) {
        // Update icon ko can reload data
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            listUncomplete[index].isImportant = !listUncomplete[index].isImportant
            ReminderStore.SharedInstance.updateReminder(reminder: listUncomplete[index])
            tasksViewControllerChangeImageButtonImportant(index, reminder, SectionsType.nonecomplete.rawValue)
        }
        else if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            listComplete[index].isImportant = !listComplete[index].isImportant
            ReminderStore.SharedInstance.updateReminder(reminder: listComplete[index])
            tasksViewControllerChangeImageButtonImportant(index, reminder, SectionsType.complete.rawValue)
        }
    }
    
    // MARK: - Change Icon Button Complete
    fileprivate func tasksViewControllerChangeImageButtonComplete(_ index: Array<Reminder>.Index, _ reminder: Reminder, _ section: Int) {
        if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: section)) as? TasksTableViewCell {
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
    
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapCompleteButtonWith reminder: Reminder) {
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            listUncomplete[index].isComplete = !listUncomplete[index].isComplete
            ReminderStore.SharedInstance.updateReminder(reminder: listUncomplete[index])
            tasksViewControllerChangeImageButtonComplete(index, reminder, SectionsType.nonecomplete.rawValue)
        } 
        else if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            listComplete[index].isComplete = !listComplete[index].isComplete
            ReminderStore.SharedInstance.updateReminder(reminder: listComplete[index])
            tasksViewControllerChangeImageButtonComplete(index, reminder, SectionsType.complete.rawValue)
        }
    }
    
    // MARK: - Change Icon Button AddToMyDay
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapAddToMyDayButtonWith reminder: Reminder) {
        reminder.isAddToMyDay = !reminder.isAddToMyDay
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        tableView.reloadData()
    }
    
    // MARK: - Change Date and Note
    func tasksDetailViewController(_ view: TasksDetailViewController, didTapSaveButtonWith reminder: Reminder) {
        if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.complete.rawValue)) as? TasksTableViewCell {
                cell.lblDateTime.text = reminder.taskDueDate.toString()
                cell.setupData(reminder)
            }
        }
        
        else if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: SectionsType.nonecomplete.rawValue)) as? TasksTableViewCell {
                cell.lblDateTime.text = reminder.taskDueDate.toString()
                cell.setupData(reminder)
            }
        }
    }
}

// MARK: - Extension TasksTableViewCell
extension TasksViewController: TasksTableViewCellDelegate {
    fileprivate func tasksTableViewCellChangeImageImportant(_ index: Array<Reminder>.Index, _ reminder: Reminder, _ section: Int) {
        if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: section)) as? TasksTableViewCell {
            if reminder.isImportant {
                cell.btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
            }
            else {
                cell.btnImportant.setImage(UIImage(named: "starred"), for: .normal)
            }
        }
    }
    
    func tasksTableViewCell(_ view: TasksTableViewCell, didTapImportantButtonWith reminder: Reminder) {
        reminder.isImportant = !reminder.isImportant
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        // Update icon ko can reload data
        if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            tasksTableViewCellChangeImageImportant(index, reminder, SectionsType.complete.rawValue)
        }
        
        else if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            tasksTableViewCellChangeImageImportant(index, reminder, SectionsType.nonecomplete.rawValue)
        }
    }
    
    fileprivate func tasksTableViewCellChangeImageComplete(_ index: Array<Reminder>.Index, _ reminder: Reminder, _ section: Int) {
        if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: section)) as? TasksTableViewCell{
            if reminder.isComplete {
                cell.btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
            }
            else {
                cell.btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
            }
        }
    }
    
    func tasksTableViewCell(_ view: TasksTableViewCell, didTapCompleteButtonWith reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = self.listUncomplete.firstIndex(where: {$0.id == reminder.id}) {
            tasksTableViewCellChangeImageComplete(index, reminder, SectionsType.nonecomplete.rawValue)
        }
       
        if let index = self.listComplete.firstIndex(where: {$0.id == reminder.id}) {
            tasksTableViewCellChangeImageComplete(index, reminder, SectionsType.complete.rawValue)
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
        
        UIView.animate(withDuration: 0.75, animations: {
            self.viewBottomConstraint.constant = 0
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
    
    func tasksAddViewDidTapDoneButtonOnKeyboard(_ view: TasksAddView) {
        subViewAddXib.isHidden = true
        btnHiddenSubView.isHidden = false
    }
}

// MARK: - Sort Reminder
extension TasksViewController: TasksMenuViewDelegate {
    fileprivate func setupReminderToListShow(_ listSortDataByDateTime: [Reminder]) {
        listComplete.removeAll()
        listUncomplete.removeAll()
        for obj in listSortDataByDateTime {
            if obj.isComplete {
                listComplete.append(obj)
            }
            else {
                listUncomplete.append(obj)
            }
        }
        subMenuViewXib.isHidden = true
        tableView.reloadData()
    }
    
    func tasksMenuViewDidTapSortByNameButton(_ view: TasksMenuView) {
        let listSortDataByName = ReminderStore.SharedInstance.getListReminderSortByName()
        setupReminderToListShow(listSortDataByName)
    }
    
    func tasksMenuViewDidTapSortByDateTimeButton(_ view: TasksMenuView) {
        let listSortDataByDateTime = ReminderStore.SharedInstance.getListReminderSortByDateTime()
        setupReminderToListShow(listSortDataByDateTime)
    }
    
    func tasksMenuViewDidTapSortByImportantButton(_ view: TasksMenuView) {
        let listSortDataByImportant = ReminderStore.SharedInstance.getListReminderSortByImportant()
        setupReminderToListShow(listSortDataByImportant)
    }
}

// MARK: - Change Color Background
extension TasksViewController: SubColorViewDelegate {
    func subColorViewDidTapSelectColor(_ view: SubColorView) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func subColorViewDidTapSelectImageFromDeviceButton(_ view: SubColorView) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func subColorView(_ view: SubColorView, didTapChangeBackgroundColorButtonWith color: UIColor) {
        self.view.backgroundColor = color
    }
    func subColorViewDidTapExitButton(_ view: SubColorView) {
        subColorViewXib.isHidden = true
    }
}

extension TasksViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.view.backgroundColor = UIColor(patternImage: chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension TasksViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        SettingStore.SharedInstance.updateSetting(setting: Setting.init(idViewController: ViewControllerType.tasks.rawValue, colorRed: Float(viewController.selectedColor.redValue), colorGreen: Float(viewController.selectedColor.greenValue), colorBlue: Float(viewController.selectedColor.blueValue), imageName: "", alpha: Float(viewController.selectedColor.alphaValue), status: StatusType.color.rawValue))
    }
}
