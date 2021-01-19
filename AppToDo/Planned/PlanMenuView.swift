//
//  PlanMenuView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 12/01/2021.
//

import UIKit

protocol PlanMenuViewDelegate: class {
    func planMenuViewDidTapSortByNameButton(_ view: PlanMenuView)
    func planMenuViewDidTapSortByDateTimeButton(_ view: PlanMenuView)
    func planMenuViewDidTapSortByImportantButton(_ view: PlanMenuView)
}

class PlanMenuView: UIView {
 
    weak var delegate: PlanMenuViewDelegate?
    
    deinit {
        print("plan menu view is deinited")
    }

    @IBAction func btnSortByNameAction(_ sender: Any) {
        delegate?.planMenuViewDidTapSortByNameButton(self)
    }
    @IBAction func btnSortByDateTimeAction(_ sender: Any) {
        delegate?.planMenuViewDidTapSortByDateTimeButton(self)
    }
    @IBAction func btnSortByImportantAction(_ sender: Any) {
        delegate?.planMenuViewDidTapSortByImportantButton(self)
    }
}
