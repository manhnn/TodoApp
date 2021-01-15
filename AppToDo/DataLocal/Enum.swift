//
//  Enum.swift
//  AppToDo
//
//  Created by Nguyen Manh on 08/01/2021.
//

import Foundation

enum SectionsType: Int {
    case nonecomplete = 0
    case complete = 1
}

enum ViewControllerType: String {
    case home = "Home"
    case myDay = "MyDay"
    case important = "Important"
    case plan = "Plan"
    case tasks = "Tasks"
}

enum StatusType: String {
    case color = "color"
    case image = "image"
}
