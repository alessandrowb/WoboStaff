//
//  SettingsViewController.swift
//  WoboStaff
//
//  Created by Alessandro on 1/9/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Private structs
    
    private struct MoveKeyboard
    {
        static let keyboardAnimationDuration: CGFloat = 0.3
        static let minimumScrollFraction: CGFloat = 0.2;
        static let maximumScrollFraction: CGFloat = 0.8;
        static let portraitKeyboardHeight: CGFloat = 216;
        static let landscapeKeyboardHeight: CGFloat = 162;
    }
    
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
    
    // MARK: - Private variables
    
    private var animateDistance: CGFloat!

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
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == newTokenTextField {
            adjustCreateKeyboard(textField)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == newTokenTextField {
            adjustHideKeyboard()
        }
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
    
    private func adjustCreateKeyboard(textField: UITextField)
    {
        let textFieldRect: CGRect = self.view.window!.convertRect(textField.bounds, fromView: textField)
        let viewRect: CGRect = self.view.window!.convertRect(self.view.bounds, fromView: self.view)
        
        let midline: CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator: CGFloat = midline - viewRect.origin.y - MoveKeyboard.minimumScrollFraction * viewRect.size.height
        let denominator: CGFloat = (MoveKeyboard.maximumScrollFraction - MoveKeyboard.minimumScrollFraction) * viewRect.size.height
        var heightFraction: CGFloat = numerator / denominator
        
        if heightFraction < 0.0 {
            heightFraction = 0.0
        } else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        
        let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if (orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.portraitKeyboardHeight * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.landscapeKeyboardHeight * heightFraction)
        }
        
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y -= animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.keyboardAnimationDuration))
        
        self.view.frame = viewFrame
        UIView.commitAnimations()
    }
    
    private func adjustHideKeyboard()
    {
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.keyboardAnimationDuration))
        
        self.view.frame = viewFrame
        UIView.commitAnimations()
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
    
    // MARK: - Private structs
    
    private struct Constants
    {
        static let buttonColor = UIColor(red: 0, green: 0.4784, blue: 1, alpha: 1.0) /* #007aff */
    }
    
    // MARK: - Init for UISettingButton
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.buttonColor.CGColor
        self.setTitleColor(Constants.buttonColor, forState: UIControlState.Normal)
    }
}