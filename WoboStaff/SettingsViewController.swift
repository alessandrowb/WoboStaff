//
//  SettingsViewController.swift
//  WoboStaff
//
//  Created by Alessandro on 1/9/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var currentTokenLabel: UILabel!
    
    @IBAction func saveButton(sender: UISettingButton)
    {
        setNewApiToken()
    }
    
    @IBAction func copyButton(sender: UISettingButton)
    {
        UIPasteboard.generalPasteboard().string = currentTokenLabel?.text
    }

    // MARK: - Textfields customization
    
    @IBOutlet weak var newTokenTextField: UITextField!
    {
        didSet {
            newTokenTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == newTokenTextField {
            textField.resignFirstResponder()
            setNewApiToken()
        }
        return true
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if hipChatConfig.currentToken == "" {
            currentTokenLabel?.text = "N/A"
        }
        else {
            currentTokenLabel?.text = hipChatConfig.currentToken
        }
    }
    
    // MARK: - Private functions
    
    private func setNewApiToken()
    {
        if newTokenTextField?.text != nil {
            if newTokenTextField.text!.trim() != "" {
                hipChatConfig.currentToken = newTokenTextField.text!.trim() as String
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }

}

// MARK: - Extensions

extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}

// MARK: - Classes

class UISettingButton: UIButton {
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = tintColor.CGColor
    }
}