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
    
    var meme: Meme?
    @IBOutlet weak var memeViewController: UIImageView!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let imageViewController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTheText(field: topTextField)
        settingTheText(field: bottomTextField)
        settingTheFunctionality()
        imageViewController.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func settingTheText(field: UITextField){
        //setting the text attributes
        topTextField.delegate = self
        bottomTextField.delegate = self
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }

    @IBAction func pickButtonPressed(_ sender: Any) {
        pick(sourceType: .photoLibrary)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        pick(sourceType: .camera)
    }
    
    func pick(sourceType: UIImagePickerControllerSourceType){
        imageViewController.delegate = self
        imageViewController.sourceType = sourceType
        memeViewController.contentMode = .scaleAspectFit
        self.present(imageViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        memeViewController.image = chosenImage
        memeViewController.contentMode = .scaleAspectFit

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
        if bottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        } 
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = 0}
        else {
            
        }
    }
    
    func generateMemedImage() -> UIImage? {
        
        hideTheToolbar(isHidden: true)
        
        // Render view to an imag
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideTheToolbar(isHidden: false)
        
        return memedImage
    }
    
    
    func hideTheToolbar(isHidden: Bool){
        bottomToolbar.isHidden = isHidden
        topToolbar.isHidden = isHidden
    }
    
    func save(memedImage: UIImage){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: memeViewController.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
       
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        if let memedImage = generateMemedImage(){
            let av = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            av.completionWithItemsHandler = {activity, completed, returned, error in
                if completed {
                    self.save(memedImage: memedImage)
                    self.dismiss(animated: true, completion: {})
                }
            }
            present(av, animated: true, completion: nil)
        }
    }
    

    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
