//
//  SettingStore.swift
//  AppToDo
//
//  Created by Nguyen Manh on 15/01/2021.
//

import Foundation
import RealmSwift

class SettingStore {
    func getBackgroundColor(idViewController: String) -> UIColor {
        let realm = try! Realm()
        let listSetting = realm.objects(RLMSetting.self)
        for obj in listSetting {
            if obj.idViewController == idViewController {
                if obj.status == StatusType.color.rawValue {
                    return UIColor.init(ciColor: CIColor.init(red: CGFloat(obj.colorRed), green: CGFloat(obj.colorGreen), blue: CGFloat(obj.colorBlue), alpha: CGFloat(obj.alpha)))
                }
                if obj.status == StatusType.image.rawValue {
                    return UIColor.init(patternImage: UIImage(named: obj.imageName)!)
                }
            }
        }
        return UIColor.systemGray6
    }
    
    func addSetting(setting: Setting) {
        let rlmSetting = RLMSetting.init(idViewController: setting.idViewController, colorRed: setting.colorRed, colorGreen: setting.colorGreen, colorBlue: setting.colorBlue, alpha: setting.alpha, imageName: setting.imageName, status: setting.status)
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(rlmSetting)
        try! realm.commitWrite()
    }
    
    func updateSetting(setting: Setting) {
        let realm = try! Realm()
        let rlmSettingInRealm = realm.objects(RLMSetting.self)
        
        for obj in rlmSettingInRealm {
            if obj.idViewController == setting.idViewController {
                try! realm.write {
                    if obj.status == StatusType.color.rawValue {
                        obj.colorRed = setting.colorRed
                        obj.colorGreen = setting.colorGreen
                        obj.colorBlue = setting.colorBlue
                    }
                    if obj.status == StatusType.image.rawValue
                    {
                        obj.imageName = setting.imageName
                    }
                }
                return
            }
        }
        // Neu chua xuat hien trong Realm thi add
        addSetting(setting: setting)
    }
    
    class var SharedInstance: SettingStore {
        struct Static {
            static let instance = SettingStore()
        }
        return Static.instance
    }
}


