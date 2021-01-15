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
    
    // MARK: - Set color for lblDateTime
    func setColorForlblDateTime(_ cell: Reminder) {
        if cell.taskDueDate == Date(timeIntervalSince1970: 0) {
            lblDateTime.textColor = .systemBlue
        }
        else if cell.taskDueDate > Date() {
            lblDateTime.textColor = .black
        }
        else if cell.taskDueDate.getDateOnlyToString() == Date().getDateOnlyToString() {
            lblDateTime.textColor = .systemPurple
        }
        else {
            lblDateTime.textColor = . systemRed
        }
    }
    
    // MARK: - Custom Cell
    func setupData(_ cell: Reminder) {
        if !cell.isComplete {
            self.lblWork.attributedText = cell.taskWorkName.unStrikeThrough()
        }
        else {
            self.lblWork.attributedText = cell.taskWorkName.strikeThrough()
        }
        
        if cell.taskDueDate != Date(timeIntervalSince1970: 0) {
            self.lblDateTime.text = cell.taskDueDate.toString()
        }
        else {
            lblDateTime.text = ""
        }
        setColorForlblDateTime(cell)
        
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
