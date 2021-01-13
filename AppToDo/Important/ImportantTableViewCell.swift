//
//  ImportantTableViewCell.swift
//  AppToDo
//
//  Created by Nguyen Manh on 10/01/2021.
//

import UIKit

protocol ImportantTableViewCellDelegate {
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
    
    var delegate: ImportantTableViewCellDelegate?
    var reminder: Reminder?
    var myDay: ImportantViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Convert Date to string
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    // MARK: - Custom Cell
    func setupData(_ cell: Reminder) {
        self.lblWork.text = cell.taskWorkName
        if cell.taskDueDate != Date(timeIntervalSince1970: 0) {
            self.lblDateTime.text = convertDateToString(date: cell.taskDueDate)
        }
        else {
            lblDateTime.text = ""
        }
        
        if cell.isImportant {
            btnImportant.setImage(UIImage(named: "starredd"), for: .normal)
        }
        if !cell.isComplete {
            self.btnComplete.setImage(UIImage(named: "recred"), for: .normal)
        }
        
        self.backgroundColor = .white
        self.cellView.backgroundColor = .white
        self.subView.backgroundColor = .white
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

