//
//  MyDayTableViewCell.swift
//  AppToDo
//
//  Created by Nguyen Manh on 02/01/2021.
//

import UIKit

protocol MyDayTableViewCellDelegate {
    func myDayTableViewCellDidTapSuccessButton(_ view: MyDayTableViewCell, index: Int)
    //func myDayTableViewCellDidTapImportantButton(_ view: MyDayTableViewCell, index: Int)
}


class MyDayTableViewCell: UITableViewCell {
    // MARK: - UI
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnImportant: UIButton!
    @IBOutlet weak var btnSuccess: UIButton!
    @IBOutlet weak var cellView: UIView!
    
    var delegate: MyDayTableViewCellDelegate?
    var index: IndexPath?
    var myDay: MyDayViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Cell
    func setupData(_ cell: Reminder) {
        self.lblWork.text = cell.taskWorkName
        self.lblDateTime.text = cell.taskDateTime
        
        if cell.isImportant {
            btnSuccess.setImage(UIImage(named: "star"), for: .normal)
        }
        else {
            btnSuccess.setImage(UIImage(named: "starred"), for: .normal)
        }
        
        if cell.isSuccess {
            self.btnSuccess.setImage(UIImage(named: "check"), for: .normal)
        }
        else {
            self.btnSuccess.setImage(UIImage(named: "rec"), for: .normal)
        }
        
        self.cellView.layer.cornerRadius = self.cellView.frame.height / 5
    }
    
    // MARK: - Buttons Action
    @IBAction func btnSuccessAction(_ sender: Any) {
        delegate?.myDayTableViewCellDidTapSuccessButton(self, index: index!.row)
    }
    
    @IBAction func btnImportantAction(_ sender: Any) {
        //delegate?.myDayTableViewCellDidTapImportantButton(self, index: index!.row)
        print("importtantkiclkkkkkkkkkkkkkkkkkkkkkkkkkkk")
    }
}



