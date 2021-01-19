//
//  TasksMenuView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 08/01/2021.
//

import UIKit

protocol TasksMenuViewDelegate: class {
    func tasksMenuViewDidTapSortByNameButton(_ view: TasksMenuView)
    func tasksMenuViewDidTapSortByDateTimeButton(_ view: TasksMenuView)
    func tasksMenuViewDidTapSortByImportantButton(_ view: TasksMenuView)
}

class TasksMenuView: UIView {
 
    weak var delegate: TasksMenuViewDelegate?
    
    deinit {
        print("tasks menu view is deinited")
    }

    @IBAction func btnSortByNameAction(_ sender: Any) {
        delegate?.tasksMenuViewDidTapSortByNameButton(self)
    }
    @IBAction func btnSortByDateTimeAction(_ sender: Any) {
        delegate?.tasksMenuViewDidTapSortByDateTimeButton(self)
    }
    @IBAction func btnSortByImportantAction(_ sender: Any) {
        delegate?.tasksMenuViewDidTapSortByImportantButton(self)
    }
    @IBAction func btnChangeTheme(_ sender: Any) {
        
    }
    
}
