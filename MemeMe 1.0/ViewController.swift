//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Alhamdani Ghifari on 22/07/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var buttomText: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let memeTextAtribute: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        NSAttributedString.Key.strokeWidth : 2.0,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 28) as Any
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.defaultTextAttributes = memeTextAtribute
        buttomText.defaultTextAttributes = memeTextAtribute
        imageView.sizeToFit()
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
    
    struct Meme {
        var topTextMeme : String
        var buttomTextMeme : String
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
        let _ = Meme(topTextMeme: topText.text!, buttomTextMeme: buttomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
}

