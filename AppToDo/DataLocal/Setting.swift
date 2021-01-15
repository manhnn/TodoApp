//
//  Setting.swift
//  AppToDo
//
//  Created by Nguyen Manh on 15/01/2021.
//

import UIKit

class Setting {
    
    var idViewController = ""
    var colorRed = Float(0.0)
    var colorGreen = Float(0.0)
    var colorBlue = Float(0.0)
    var alpha = Float(0.0)
    var imageName = ""
    var status = ""
        
    convenience init(idViewController: String, colorRed: Float, colorGreen: Float, colorBlue: Float, imageName: String, alpha: Float, status: String) {
        self.init()
        self.idViewController = idViewController
        self.colorRed = colorRed
        self.colorGreen = colorGreen
        self.colorBlue = colorBlue
        self.alpha = alpha
        self.imageName = imageName
        self.status = status
    }
}
