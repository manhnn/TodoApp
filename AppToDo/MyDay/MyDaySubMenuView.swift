//
//  MyDaySubMenuView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 09/01/2021.
//

import UIKit

protocol MyDaySubMenuViewDelegate {
    func myDaySubMenuViewDidTapSortByNameButton(_ view: MyDaySubMenuView)
    func myDaySubMenuViewDidTapSortByDateTimeButton(_ view: MyDaySubMenuView)
    func myDaySubMenuViewDidTapSortByImportantButton(_ view: MyDaySubMenuView)
}

class MyDaySubMenuView: UIView {

    var delegate: MyDaySubMenuViewDelegate?
    
    @IBAction func btnDidTapSortByNameButton(_ sender: Any) {
        delegate?.myDaySubMenuViewDidTapSortByNameButton(self)
    }
    
    @IBAction func btnDidTapSortByDateTimeButton(_ sender: Any) {
        delegate?.myDaySubMenuViewDidTapSortByDateTimeButton(self)
    }
    @IBAction func btnDidTapSortByImportantButton(_ sender: Any) {
        delegate?.myDaySubMenuViewDidTapSortByImportantButton(self)
    }
}
