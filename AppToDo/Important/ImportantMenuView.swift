//
//  ImportantMenuView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 10/01/2021.
//

import UIKit

protocol ImportantMenuViewDelegate: class {
    func importantMenuViewDidTapSortByNameButton(_ view: ImportantMenuView)
    func importantMenuViewDidTapSortByDateTimeButton(_ view: ImportantMenuView)
}

class ImportantMenuView: UIView {
 
    weak var delegate: ImportantMenuViewDelegate?
    
    deinit {
        print("important menu view is deinited")
    }

    @IBAction func btnSortByNameAction(_ sender: Any) {
        delegate?.importantMenuViewDidTapSortByNameButton(self)
    }
    @IBAction func btnSortByDateTimeAction(_ sender: Any) {
        delegate?.importantMenuViewDidTapSortByDateTimeButton(self)
    }
}
