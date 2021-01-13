//
//  ImportantMenuView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 10/01/2021.
//

import UIKit

protocol ImportantMenuViewDelegate {
    func importantMenuViewDidTapSortByNameButton(_ view: ImportantMenuView)
    func importantMenuViewDidTapSortByDateTimeButton(_ view: ImportantMenuView)
}

class ImportantMenuView: UIView {
 
    var delegate: ImportantMenuViewDelegate?

    @IBAction func btnSortByNameAction(_ sender: Any) {
        delegate?.importantMenuViewDidTapSortByNameButton(self)
    }
    @IBAction func btnSortByDateTimeAction(_ sender: Any) {
        delegate?.importantMenuViewDidTapSortByDateTimeButton(self)
    }
}
