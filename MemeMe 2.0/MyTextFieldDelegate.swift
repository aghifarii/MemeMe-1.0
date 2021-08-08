//
//  MyTextFieldDelegate.swift
//  MemeMe 2.0
//
//  Created by Alhamdani Ghifari on 30/07/21.
//

import Foundation
import UIKit

class MyTextFieldDelegate : NSObject, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = " "
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
