//
//  SubColorView.swift
//  AppToDo
//
//  Created by Nguyen Manh on 14/01/2021.
//

import UIKit

protocol SubColorViewDelegate {
    func subColorView(_ view: SubColorView, didTapChangeBackgroundColorButtonWith color: UIColor)
    func subColorViewDidTapExitButton(_ view: SubColorView)
}

class SubColorView: UIView {
    var delegate: SubColorViewDelegate?
    
    
    @IBAction func changeColorPurple(_ sender: Any) {
        let color = UIColor.init(displayP3Red: 97 / 255, green: 111 / 255, blue: 185 / 255, alpha: 1)
        delegate?.subColorView(self, didTapChangeBackgroundColorButtonWith: color)
    }
    
    @IBAction func changeColorDarkGreen(_ sender: Any) {
        let color = UIColor.init(displayP3Red: 68 / 255, green: 118 / 255, blue: 124 / 255, alpha: 1)
        delegate?.subColorView(self, didTapChangeBackgroundColorButtonWith: color)
    }
    
    @IBAction func changeColorCyan(_ sender: Any) {
        let color = UIColor.init(displayP3Red: 86 / 255, green: 185 / 255, blue: 248 / 255, alpha: 1)
        delegate?.subColorView(self, didTapChangeBackgroundColorButtonWith: color)
    }
    
    @IBAction func changeColorOrange(_ sender: Any) {
        let color = UIColor.init(displayP3Red: 255 / 255, green: 117 / 255, blue: 95 / 255, alpha: 1)
        delegate?.subColorView(self, didTapChangeBackgroundColorButtonWith: color)
    }
    
    @IBAction func changeColorPink(_ sender: Any) {
        let color = UIColor.init(displayP3Red: 251 / 255, green: 229 / 255, blue: 233 / 255, alpha: 1)
        delegate?.subColorView(self, didTapChangeBackgroundColorButtonWith: color)
    }
    
    @IBAction func changeColorLightGreen(_ sender: Any) {
        let color = UIColor.init(displayP3Red: 218 / 255, green: 240 / 255, blue: 239 / 255, alpha: 1)
        delegate?.subColorView(self, didTapChangeBackgroundColorButtonWith: color)
    }
    
    @IBAction func changeColorGray(_ sender: Any) {
        let color = UIColor.init(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1)
        delegate?.subColorView(self, didTapChangeBackgroundColorButtonWith: color)
    }
    
    
    @IBAction func exitViewAction(_ sender: Any) {
        delegate?.subColorViewDidTapExitButton(self)
    }
}
