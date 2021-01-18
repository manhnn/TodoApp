//
//  SettingStore.swift
//  AppToDo
//
//  Created by Nguyen Manh on 15/01/2021.
//

import Foundation
import RealmSwift

class SettingStore {
    fileprivate func makeLinkURLFromUIImage(_ obj: RLMSetting) -> UIColor {
        let dir = NSHomeDirectory().appending("/Documents")
        if !FileManager.default.fileExists(atPath: dir)  {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: dir), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let url = NSURL.fileURL(withPath: dir + "/" + obj.imagePath)
        do {
            let data = try Data(contentsOf: url)
            return UIColor.init(patternImage: UIImage(data: data)!)
        }
        catch{
            print(error)
        }
        return UIColor.init(red: 97 / 255, green: 111 / 255, blue: 255 / 255, alpha: 1)
    }
    
    func getBackgroundColor(idViewController: String) -> UIColor {
        let realm = try! Realm()
        let listSetting = realm.objects(RLMSetting.self)
        for obj in listSetting {
            if obj.idViewController == idViewController {
                if obj.status == StatusType.color.rawValue {
                    return UIColor.init(ciColor: CIColor.init(red: CGFloat(obj.colorRed), green: CGFloat(obj.colorGreen), blue: CGFloat(obj.colorBlue), alpha: CGFloat(obj.alpha)))
                }
                if obj.status == StatusType.image.rawValue {
                    return makeLinkURLFromUIImage(obj)
                }
            }
        }
        return UIColor.init(red: 97 / 255, green: 111 / 255, blue: 255 / 255, alpha: 1)
    }
    
    func addSetting(setting: Setting) {
        let rlmSetting = RLMSetting.init(idViewController: setting.idViewController, colorRed: setting.colorRed, colorGreen: setting.colorGreen, colorBlue: setting.colorBlue, alpha: setting.alpha, imagePath: setting.imageName, status: setting.status)
        
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
                    obj.status = setting.status
                }
            }
        }
        
        for obj in rlmSettingInRealm {
            if obj.idViewController == setting.idViewController {
                try! realm.write {
                    if obj.status == StatusType.color.rawValue {
                        obj.colorRed = setting.colorRed
                        obj.colorGreen = setting.colorGreen
                        obj.colorBlue = setting.colorBlue
                        obj.alpha = setting.alpha
                    }
                    if obj.status == StatusType.image.rawValue
                    {
                        obj.imagePath = setting.imageName
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


