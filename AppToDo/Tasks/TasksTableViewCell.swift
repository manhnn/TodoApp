//
//  TasksTableViewCell.swift
//  AppToDo
//
//  Created by Nguyen Manh on 08/01/2021.
//

import UIKit

protocol TasksTableViewCellDelegate {
    func tasksTableViewCell(_ view: TasksTableViewCell, didTapCompleteButtonWith reminder: Reminder)
    func tasksTableViewCell(_ view: TasksTableViewCell, didTapImportantButtonWith reminder: Reminder)
}

class TasksTableViewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subView: UIView!
    
    var delegate: TasksTableViewCellDelegate?
    var reminder: Reminder?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Get nowDay
    func getDateNow() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }
    
    // MARK: - Custom Cell
    func setupData(_ cell: Reminder) {
        self.lblWork.text = cell.taskWorkName
        self.lblDateTime.text = cell.taskDueDate
        
        if cell.isImportant {
            btnImportant.setImage(UIImage(named: "starblack"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starred"), for: .normal)
        }
        
        if cell.isComplete {
            self.btnComplete.setImage(UIImage(named: "checkblack"), for: .normal)
        }
        else {
            self.btnComplete.setImage(UIImage(named: "recblack"), for: .normal)
        }
        
        self.backgroundColor = .white
        self.cellView.backgroundColor = .white
        self.subView.backgroundColor = .white
        self.cellView.layer.cornerRadius = self.cellView.frame.height / 5
    }
    
    // MARK: - Buttons Action
    @IBAction func btnSuccessAction(_ sender: Any) {
        delegate?.tasksTableViewCell(self, didTapCompleteButtonWith: reminder!)
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        delegate?.tasksTableViewCell(self, didTapImportantButtonWith: reminder!)
    }
}
