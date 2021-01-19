//
//  SubColorView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 14/01/2021.
//

import UIKit

protocol SubColorViewDelegate: class {
    func subColorViewDidTapSelectImageFromDeviceButton(_ view: SubColorView)
    func subColorViewDidTapSelectColor(_ view: SubColorView)
    func subColorViewDidTapExitButton(_ view: SubColorView)
}

class SubColorView: UIView  {
    weak var delegate: SubColorViewDelegate?
    
    deinit {
        print("subcolor view is deinited")
    }
    
    @IBAction func selectImageFromDevice(_ sender: Any) {
        delegate?.subColorViewDidTapSelectImageFromDeviceButton(self)
    }
    
    @IBAction func selectColorFromColorPicker(_ sender: Any) {
        delegate?.subColorViewDidTapSelectColor(self)
    }
    
    @IBAction func exitViewAction(_ sender: Any) {
        delegate?.subColorViewDidTapExitButton(self)
    }
}

