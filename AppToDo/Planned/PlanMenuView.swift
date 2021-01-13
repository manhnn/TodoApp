//
//  PlanMenuView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 12/01/2021.
//

import UIKit

protocol PlanMenuViewDelegate {
    func planMenuViewDidTapSortByNameButton(_ view: PlanMenuView)
    func planMenuViewDidTapSortByDateTimeButton(_ view: PlanMenuView)
    func planMenuViewDidTapSortByImportantButton(_ view: PlanMenuView)
}

class PlanMenuView: UIView {
 
    var delegate: PlanMenuViewDelegate?

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
