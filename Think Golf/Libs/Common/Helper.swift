//
//  Helper.swift
//  VogCalegory
//
//  Created by Mohsin on 9/4/15.
//  Copyright (c) 2017 MJ. All rights reserved.
//

import Foundation
import SVProgressHUD

// Global xConstants

//Notifications
let kNotificationStartAutoRefreshTimer = "StartAutoRefreshTimer"

//Placeholders
let kPlaceholderAddNotes = "Add doctor notes here"

//Alerts
let kAlertButtonOk = "Ok"
let kAlertButtonCancel = "Cancel"
let kAlertTitleCommon = "Think Golf"
let kAlertMessageNetworkConnection = "Make sure your device is connected to the internet."
let kAlertTitleNetworkConnection = "No Internet Connection"
let kAlertMessageInvalidCredential = "The Username or Password is incorrect"
let kAlertMessageLoginFailed = "Login Failed"
let kAlertMessageToLogout = "Are you sure you want to logout?"
let kAlertMessageEmptyMail = "Please enter your email"
let kAlertMessageInvalidMail = "Please enter your email"
let kAlertMessageEmptyPass = "Login Failed"
let kAlertMessageErrorSubmittingNotes = "Could not submit the notes. Please try again later"
let kAlertMessageErrorEnterNotes = "Please enter notes"
let kAlertMessageErrorUpdateNotes = "There was a problem updating your info.  Please try again."
//RegEx
let kRegExEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

//Enums
enum ApponintmentType : Int {
    case waiting
    case scheduled
    case unknown
}

//Font
let FontUITextRegular = "SFUIText-Regular"

typealias BasicBlock = () -> (Void)

func showSpinner(_ message: String) {
    SVProgressHUD.show(withStatus: message)
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
}

func dismissSpinner() {
    SVProgressHUD.dismiss()
}

func dismissSpinnerWithError(_ message: String) {
    SVProgressHUD.showError(withStatus: message)
}
func printLog(_ log: AnyObject?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
    print(formatter.string(from: Date() as Date), terminator: "")
    if log == nil {
        print("nil")
    }
    else {
        print(log!)
    }
}


func dismissModalStack(_ viewController: UIViewController, animated: Bool, completionBlock: BasicBlock?) {
    if viewController.presentingViewController != nil {
        var vc = viewController.presentingViewController!
        while (vc.presentingViewController != nil) {
            vc = vc.presentingViewController!;
        }
        vc.dismiss(animated: animated, completion: nil)
        
        if let c = completionBlock {
            c()
        }
    }
}

//Display Alert - With custom button title
func showAlert(_ title: String, message: String,buttonTitle:String)
{
    let alertController = DBAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
    alertController.show()
}


func appendAuthorizationHeader(_ token: String?, request: NSMutableURLRequest) {
    if let t = token {
        request.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
    }
    
}
