//
//  ViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 01/01/2021.
//

import UIKit

class Home: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer()
        self.mainView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tapGestureHiddenColorView))
    }
    
    @objc func tapGestureHiddenColorView() {
        colorView.isHidden = true
    }
    
    @IBAction func changeThemeButton(_ sender: Any) {
        colorView.isHidden = false
    }
    
    @IBAction func selectPhotoFromDevice(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func changeColorPurple(_ sender: Any) {
        mainView.backgroundColor = UIColor.init(displayP3Red: 97 / 255, green: 111 / 255, blue: 185 / 255, alpha: 1)
    }
    
    @IBAction func changeColorDarkGreen(_ sender: Any) {
        mainView.backgroundColor = UIColor.init(displayP3Red: 68 / 255, green: 118 / 255, blue: 124 / 255, alpha: 1)
    }
    
    @IBAction func changeColorCyan(_ sender: Any) {
        mainView.backgroundColor = UIColor.init(displayP3Red: 86 / 255, green: 185 / 255, blue: 248 / 255, alpha: 1)
    }
    
    @IBAction func changeColorOrange(_ sender: Any) {
        mainView.backgroundColor = UIColor.init(displayP3Red: 255 / 255, green: 117 / 255, blue: 95 / 255, alpha: 1)
    }
    
    @IBAction func changeColorPink(_ sender: Any) {
        mainView.backgroundColor = UIColor.init(displayP3Red: 251 / 255, green: 229 / 255, blue: 233 / 255, alpha: 1)
    }
    
    @IBAction func changeColorLightGreen(_ sender: Any) {
        mainView.backgroundColor = UIColor.init(displayP3Red: 218 / 255, green: 240 / 255, blue: 239 / 255, alpha: 1)
    }
    
    @IBAction func changeColorGray(_ sender: Any) {
        mainView.backgroundColor = UIColor.init(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1)
    }
}

extension Home: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        mainView.backgroundColor = UIColor(patternImage: chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
}

    

