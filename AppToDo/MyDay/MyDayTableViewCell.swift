//
//  MyDayTableViewCell.swift
//  AppToDo
//
//  Created by Nguyen Manh on 05/01/2021.
//

import UIKit

protocol MyDayTableViewCellDelegate {
    func myDayTableViewCell(_ view: MyDayTableViewCell, didTapCompleteButtonWith reminder: Reminder)
    func myDayTableViewCell(_ view: MyDayTableViewCell, didTapImportantButtonWith reminder: Reminder)
}

class MyDayTableViewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subView: UIView!
    
    var delegate: MyDayTableViewCellDelegate?
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
            lblDateTime.textColor = .systemRed
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
        
        self.lblDateTime.text = cell.taskDueDate.toString()
        
        if cell.taskDueDate != Date(timeIntervalSince1970: 0) {
            self.lblDateTime.text = cell.taskDueDate.toString()
        }
        else {
            lblDateTime.text = ""
        }
        setColorForlblDateTime(cell)
        
        if cell.isImportant {
            btnImportant.setImage(UIImage(named: "star"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starred"), for: .normal)
        }
        
        if cell.isComplete {
            self.btnComplete.setImage(UIImage(named: "check"), for: .normal)
        }
        else {
            self.btnComplete.setImage(UIImage(named: "rec"), for: .normal)
        }
        
        self.cellView.layer.cornerRadius = self.cellView.frame.height / 5
    }
    
    // MARK: - Buttons Action
    @IBAction func btnSuccessAction(_ sender: Any) {
        delegate?.myDayTableViewCell(self, didTapCompleteButtonWith: reminder!)
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        delegate?.myDayTableViewCell(self, didTapImportantButtonWith: reminder!)
    }
}
