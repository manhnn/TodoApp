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
        self.view.backgroundColor = SettingStore.SharedInstance.getBackgroundColor(idViewController: ViewControllerType.important.rawValue)
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
            heightKeyboard = keyboardRectangle.height
        }
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
    
    func addDataToListImportant() {
        for obj in listReminder {
            listImportant.append(obj)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - UITableViewDataSource 
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
        return 80.0
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
        
        UIView.animate(withDuration: 0.4, animations: {
            self.viewBottomConstraint.constant = self.heightKeyboard!
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
    
    // MARK: - Change color for label in cell
    func importantDetailViewController(_ view: ImportantDetailViewController, didTapSaveButtonWith reminder: Reminder) {
        if let index = self.listImportant.firstIndex(where: {$0.id == reminder.id}) {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ImportantTableViewCell {
                cell.lblDateTime.text = reminder.taskDueDate.toString()
                cell.setupData(reminder)
            }
        }
    }
}

// MARK: - Extension ImportantTableViewCell
extension ImportantViewController: ImportantTableViewCellDelegate {
    fileprivate func importantViewControllerUpdateRemoveAndDeleteRowsWith(_ reminder: Reminder) {
        ReminderStore.SharedInstance.updateReminder(reminder: reminder)
        
        if let index = listImportant.firstIndex(where: {$0.id == reminder.id}) {
            listImportant.remove(at: index)
            tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .left)
        }
    }
    
    func importantTableViewCell(_ view: ImportantTableViewCell, didTapCompleteButtonWith reminder: Reminder) {
        reminder.isComplete = !reminder.isComplete
        importantViewControllerUpdateRemoveAndDeleteRowsWith(reminder)
    }
    
    func importantTableViewCell(_ view: ImportantTableViewCell, didTapImportantButtonWith reminder: Reminder) {
        reminder.isImportant = !reminder.isImportant
        importantViewControllerUpdateRemoveAndDeleteRowsWith(reminder)
    }
}

// MARK: - Extension ImportantAddView Reload Data
extension ImportantViewController: ImportantAddViewDelegate {
    func importantAddView(_ view: ImportantAddView, didAddItemSuccessWith reminder: Reminder) {
        listImportant.insert(reminder, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .middle)
        tableView.endUpdates()
        
        UIView.animate(withDuration: 0.75, animations: {
            self.viewBottomConstraint.constant = 0
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
    
    func importantAddViewDidTapDoneButtonOnKeyboard(_ view: ImportantAddView) {
        subViewAddXib.isHidden = true
        btnHiddenSubView.isHidden = false
    }
}

extension ImportantViewController: ImportantMenuViewDelegate {
    fileprivate func setupReminderToListShow(_ listSortDataByName: [Reminder]) {
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
    
    func importantMenuViewDidTapSortByNameButton(_ view: ImportantMenuView) {
        let listSortDataByName = ReminderStore.SharedInstance.getListReminderSortByName()
        setupReminderToListShow(listSortDataByName)
    }
    
    func importantMenuViewDidTapSortByDateTimeButton(_ view: ImportantMenuView) {
        let listSortDataByDateTime = ReminderStore.SharedInstance.getListReminderSortByDateTime()
        setupReminderToListShow(listSortDataByDateTime)
    }
}

// MARK: - Change Color Background
extension ImportantViewController: SubColorViewDelegate {
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
    func subColorViewDidTapExitButton(_ view: SubColorView) {
        subColorViewXib.isHidden = true
    }
}

extension ImportantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.view.backgroundColor = UIColor(patternImage: chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImportantViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        SettingStore.SharedInstance.updateSetting(setting: Setting.init(idViewController: ViewControllerType.important.rawValue, colorRed: Float(viewController.selectedColor.redValue), colorGreen: Float(viewController.selectedColor.greenValue), colorBlue: Float(viewController.selectedColor.blueValue), imageName: "", alpha: Float(viewController.selectedColor.alphaValue), status: StatusType.image.rawValue))
    }
}
