//
//  ViewController.swift
//  MemeMe
//
//  Created by Ndoo H on 02/12/2018.
//  Copyright © 2018 Ndoo H. All rights reserved.
//

import UIKit

class EdtiorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        setTextFields(textInput: topText, defaultText: "TOP")
        setTextFields(textInput: bottomText, defaultText: "BOTTOM")
       tabBarController?.tabBar.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
       
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // MARK:  defualt text field attributes
    func setTextFields(textInput: UITextField!, defaultText: String) {
        
        let memeTextAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -2.0]
        textInput.text = defaultText
        textInput.defaultTextAttributes = memeTextAttributes
        textInput.delegate = self
        textInput.textAlignment = .center
        textInput.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        pickImage(sourceType: .camera)
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        pickImage(sourceType: .photoLibrary)
    }
    
    func pickImage(sourceType:UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK:  after take img
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    // MARK:  if the user decied to discard img
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as!
            AppDelegate).memes.append(meme)
    }
// MARK:  share
    @IBAction func shareAction(sender: AnyObject) {
        let memedImage = generateMemedImage()
    
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if success{
                self.save()
                self.dismiss(animated: true, completion: nil)
                self.navigationController!.popViewController(animated: true)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        toolBarVisible(visible: false)
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // Show toolbar and navbar
        toolBarVisible(visible: true)
        return memedImage
    }
    
    // MARK: toolbar functions
    func toolBarVisible(visible: Bool){
        navBar.isHidden = !visible
        toolBar.isHidden = !visible
    }
    // MARK: cancel image selection
    @IBAction func cancelMainScreen(sender: AnyObject) {
        imagePickerView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        shareButton.isEnabled = false
        self.dismiss(animated: true, completion: nil) // removed self
        self.navigationController!.popViewController(animated: true)

    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:))   , name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
     // MARK: shift the view's frame up only on bottom text field
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y == 0.0{
            view.frame.origin.y = -getKeyboardHeight(notification)
                    }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder{
            view.frame.origin.y = 0.0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    //MARK: clear textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topText.text == "TOP" || bottomText.text == "BOTTOM" {
            textField.text = ""
        }
    }
    // MARK: hide keyboard with return 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)   // removed self
        return false
    }
   
}
