//
//  PlanTableViewCell.swift
//  AppToDo
//
//  Created by Nguyen Manh on 12/01/2021.
//

import UIKit

protocol PlanTableViewCellDelegate {
    func planTableViewCell(_ view: PlanTableViewCell, didTapCompleteButtonWith reminder: Reminder)
    func planTableViewCell(_ view: PlanTableViewCell, didTapImportantButtonWith reminder: Reminder)
}

class PlanTableViewCell: UITableViewCell {

    // MARK: - UI
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subView: UIView!
    
    var delegate: PlanTableViewCellDelegate?
    var reminder: Reminder?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Cell
    func setupData(_ cell: Reminder) {
        self.lblWork.text = cell.taskWorkName
        self.lblDateTime.text = cell.taskDueDate
        
        if cell.isImportant {
            btnImportant.setImage(UIImage(named: "stargreen"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starredgreen"), for: .normal)
        }
        if !cell.isComplete {
            self.btnComplete.setImage(UIImage(named: "recgreen"), for: .normal)
        }
        
        self.backgroundColor = .white
        self.cellView.backgroundColor = .white
        self.subView.backgroundColor = .white
        self.cellView.layer.cornerRadius = self.cellView.frame.height / 5
    }
    
    // MARK: - Buttons Action
    @IBAction func btnCompleteAction(_ sender: Any) {
        delegate?.planTableViewCell(self, didTapCompleteButtonWith: reminder!)
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        reminder!.isImportant = !reminder!.isImportant
        delegate?.planTableViewCell(self, didTapImportantButtonWith: reminder!)
        
        if reminder!.isImportant {
            btnImportant.setImage(UIImage(named: "stargreen"), for: .normal)
        }
        else {
            btnImportant.setImage(UIImage(named: "starredgreen"), for: .normal)
        }
    }
}
