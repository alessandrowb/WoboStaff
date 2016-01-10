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
    
    private struct Constants
    {
        static let noTokenText = "N/A"
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
            adjustShowKeyboard(textField)
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
            currentTokenLabel?.text = Constants.noTokenText
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
                hipChatConfig.currentToken = newTokenTextField.text!.trim()
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    private func adjustShowKeyboard(textField: UITextField)
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