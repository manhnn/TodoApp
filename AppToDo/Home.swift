//
//  ViewController.swift
//  AppToDo
//
//  Created by Nguyen Manh on 01/01/2021.
//

import UIKit

class Home: UIViewController {
    @IBOutlet weak var subColorViewXib: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SettingStore.SharedInstance.getBackgroundColor(idViewController: "Home")
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tapGestureHiddenColorView))
    }
    
    // MARK: - Show SubColorView.xib
    func showColorViewXib() {
        let nib = UINib(nibName: "SubColorView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! SubColorView
        view.frame = subColorViewXib.bounds
        subColorViewXib.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: subColorViewXib.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: subColorViewXib.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: subColorViewXib.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: subColorViewXib.trailingAnchor).isActive = true
        view.delegate = self
    }
    
    @objc func tapGestureHiddenColorView() {
        subColorViewXib.isHidden = true
    }
    
    @IBAction func changeThemeButton(_ sender: Any) {
        subColorViewXib.isHidden = false
        showColorViewXib()
    }
}

extension Home: SubColorViewDelegate {
    func subColorViewDidTapSelectColor(_ view: SubColorView) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func subColorViewDidTapSelectImageFromDeviceButton(_ view: SubColorView) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    func subColorViewDidTapExitButton(_ view: SubColorView) {
        subColorViewXib.isHidden = true
    }
}

extension Home: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.view.backgroundColor = UIColor(patternImage: chosenImage)
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension Home: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        
        SettingStore.SharedInstance.updateSetting(setting: Setting.init(idViewController: "Home", colorRed: Float(viewController.selectedColor.redValue), colorGreen: Float(viewController.selectedColor.greenValue), colorBlue: Float(viewController.selectedColor.blueValue), imageName: "", alpha: Float(viewController.selectedColor.alphaValue), status: "color"))
    }
}

    

