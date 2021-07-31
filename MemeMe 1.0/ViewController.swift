//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Alhamdani Ghifari on 22/07/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let textDelegate = MyTextFieldDelegate()
    
    let memeTextAtribute: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 28) as Any
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.defaultTextAttributes = memeTextAtribute
        bottomText.defaultTextAttributes = memeTextAtribute
        imageView.sizeToFit()
        self.topText.delegate = textDelegate
        self.bottomText.delegate = textDelegate
    }

    @IBAction func pickImageFromAlbum(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: save)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        actionButton.isEnabled = imageView.image != nil
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewWillDisappear(animated)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            imageView.sizeToFit()
        }
        dismiss(animated: true, completion: nil)
        actionButton.isEnabled = imageView.image != nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageView.image = nil
        dismiss(animated: true, completion: nil)
        actionButton.isEnabled = imageView.image != nil
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isEditing == true {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    struct Meme {
        var topTextMeme : String
        var bottomTextMeme : String
        var originalImage : UIImage
        var memedImage : UIImage
    }
    
    func generateMemedImage() -> UIImage {
        //Hide Toolbar and navbar
        navigationBar.isHidden = true
        toolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Show tollbar and navbar
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    func save(){
        let _ = Meme(topTextMeme: topText.text!, bottomTextMeme: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    
}

