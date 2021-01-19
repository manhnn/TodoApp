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
        
        self.view.backgroundColor = SettingStore.SharedInstance.getBackgroundColor(idViewController: ViewControllerType.home.rawValue)
        
        
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(tapGestureHiddenColorView))
    }

    deinit {
        print("HOME DEINITED")
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
    
    // MARK: - Buttons Action
    @IBAction func showTasksViewControllerButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tasksViewController = storyBoard.instantiateViewController(identifier: "TasksViewController") as! TasksViewController
        navigationController?.pushViewController(tasksViewController, animated: true)
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
        //picker.selectedColor = self.view.backgroundColor!
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
    
    func makeURLImageToDocument() -> URL {
        let directory = NSHomeDirectory().appending("/Documents")
        if !FileManager.default.fileExists(atPath: directory)  {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directory), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let url = NSURL.fileURL(withPath: directory + "/homebackground.jpg")
        return url
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.view.backgroundColor = UIColor(patternImage: chosenImage)
        picker.dismiss(animated: true, completion: nil)
        
        let url = makeURLImageToDocument()
        
        // Load image from URL
        do {
            try chosenImage.jpegData(compressionQuality: 1)?.write(to: url, options: .atomic)
        }
        catch {
            print(error)
        }
        
        do {
            let url = URL(string: url.relativeString)
            let data = try Data(contentsOf: url!)
            self.view.backgroundColor = UIColor(patternImage: UIImage(data: data)!)
        }
        catch{
            print(error)
        }
        
        SettingStore.SharedInstance.updateSetting(setting: Setting.init(idViewController: ViewControllerType.home.rawValue, colorRed: 0, colorGreen: 0, colorBlue: 0, imageName: "homebackground.jpg", alpha: 0, status: StatusType.image.rawValue))
    }
}

extension Home: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        
        SettingStore.SharedInstance.updateSetting(setting: Setting.init(idViewController: ViewControllerType.home.rawValue, colorRed: Float(viewController.selectedColor.redValue), colorGreen: Float(viewController.selectedColor.greenValue), colorBlue: Float(viewController.selectedColor.blueValue), imageName: "", alpha: Float(viewController.selectedColor.alphaValue), status: StatusType.color.rawValue))
    }
}

    

