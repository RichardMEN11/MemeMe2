//
//  ViewController.swift
//  MemeMe2
//
//  Created by Richard Menning on 21.04.18.
//  Copyright © 2018 Richard Menning. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var memeViewController: UIImageView!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let imageViewController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        settingTheText(field: topTextField)
        settingTheText(field: bottomTextField)
        settingTheFunctionality()
        
    }
    
    func settingTheText(field: UITextField){
        //setting the text attributes
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3]
        
        field.defaultTextAttributes = memeTextAttributes
        field.textAlignment = .center
    }
    
    func settingTheFunctionality(){
        //setting the functionality of the view
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeViewController.image = nil
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false {
            return print("photo library not available")
        }
        imageViewController.delegate = self
        imageViewController.sourceType = .photoLibrary
        self.present(imageViewController, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false {
            return print("camera not available")
        }
        imageViewController.delegate = self
        imageViewController.sourceType = .camera
        memeViewController.contentMode = .scaleAspectFit
        self.present(imageViewController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        memeViewController.image = chosenImage
        memeViewController.contentMode = .scaleAspectFit
        self.shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 100 && textField.text == "" {
            textField.text = "TOP"
        } else if textField.tag == 101 && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func generateMemedImage() -> UIImage? {
        
        bottomToolbar.isHidden = true
        shareButton.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        bottomToolbar.isHidden = false
        shareButton.isHidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage){
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: memeViewController.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
       
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        //TODO: programm the right share function
        if let memedImage = generateMemedImage(){
            let av = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            av.completionWithItemsHandler = { (_, success, _, _) in
                if success {
                    self.save(memedImage: memedImage)
                }
            }
            present(av, animated: true, completion: nil)
        }
}

}
