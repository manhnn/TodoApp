//
//  ImportantTableViewCell.swift
//  AppToDo
//
//  Created by Nguyen Manh on 10/01/2021.
//

import UIKit

protocol ImportantTableViewCellDelegate: class {
    func importantTableViewCell(_ view: ImportantTableViewCell, didTapCompleteButtonWith reminder: Reminder)
    func importantTableViewCell(_ view: ImportantTableViewCell, didTapImportantButtonWith reminder: Reminder)
}

class ImportantTableViewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subView: UIView!
    
    weak var delegate: ImportantTableViewCellDelegate?
    var reminder: Reminder?
    var myDay: ImportantViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    deinit {
        print("important cell is deinited")
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
            btnImportant.setImage(UIImage(named: "starredd"), for: .normal)
        }
        if !cell.isComplete {
            self.btnComplete.setImage(UIImage(named: "recred"), for: .normal)
        }
        
        self.cellView.layer.cornerRadius = self.cellView.frame.height / 5
    }
    
    // MARK: - Buttons Action
    @IBAction func btnCompleteAction(_ sender: Any) {
        delegate?.importantTableViewCell(self, didTapCompleteButtonWith: reminder!)
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        delegate?.importantTableViewCell(self, didTapImportantButtonWith: reminder!)
    }
}

