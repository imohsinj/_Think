//
//  LoginVC.swift
//  Think Golf
//
//  Created by Mohsin Jamadar on 15/02/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import BWWalkthrough
import EZAlertController
import Alamofire

class RegistrationVC: UIViewController, BWWalkthroughViewControllerDelegate,UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var txtFieldUsername: ValidatingTextField!
    @IBOutlet weak var txtFieldEmail: ValidatingTextField!
    @IBOutlet weak var txtFieldPass: ValidatingTextField!
    @IBOutlet weak var txtFieldConfirmPass: ValidatingTextField!
    @IBOutlet weak var txtFieldPhone: ValidatingTextField!
    
    //iVars
    var callTimer:Timer!
    let userInfo =  UserInfo()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareUI()
        setupTextFieldValidation()
        registerTempDataPopulater()
    }
    
    func registerTempDataPopulater() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.autoLogin))
        gestureRecognizer.numberOfTapsRequired = 3
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func autoLogin(){
        txtFieldUsername.text = "mj1@mj.com"
        txtFieldPass.text = "mj1"
        txtFieldEmail.text = "mj1@mj.com"
        txtFieldConfirmPass.text = "mj1"
        txtFieldPhone.text = "987654321"
        onTapSignup(UIButton())
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        }

    // MARK: - Initial Setup
    func prepareUI(){
        txtFieldPhone.delegate = self
        
        txtFieldUsername.layer.borderWidth = 1.0
        txtFieldUsername.layer.borderColor = UIColor.white.cgColor
        txtFieldPass.layer.borderWidth = 1.0
        txtFieldPass.layer.borderColor = UIColor.white.cgColor
        txtFieldEmail.layer.borderWidth = 1.0
        txtFieldEmail.layer.borderColor = UIColor.white.cgColor
        txtFieldConfirmPass.layer.borderWidth = 1.0
        txtFieldConfirmPass.layer.borderColor = UIColor.white.cgColor
        txtFieldPhone.layer.borderWidth = 1.0
        txtFieldPhone.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK:- Validations
    func setupTextFieldValidation() {
        self.txtFieldUsername.required = true
        self.txtFieldPass.required = true
        self.txtFieldEmail.required = true
        self.txtFieldConfirmPass.required = true
        self.txtFieldPhone.required = true
        self.txtFieldPhone.validationType = .NumericOnly
    }
    
    func validate() -> Bool {
        var flag = true
        let textFields = [self.txtFieldUsername,self.txtFieldPass,self.txtFieldEmail,self.txtFieldConfirmPass,self.txtFieldPhone]
        for textField in textFields {
            flag = (textField?.valid())! && flag
        }
        return flag
    }

    // MARK: - Event Listeners
    @IBAction func onTapSignup(_ sender: Any) {
        let userName = txtFieldUsername.text!
        let pass = txtFieldPass.text!
        let cpass = txtFieldConfirmPass.text!
        let phone = txtFieldPhone.text!
        let email = txtFieldEmail.text!
        
        if !self.validate() {
            showAlert("Attention", message: "Please fill in all required fields.",buttonTitle: "Ok")
            return
        }
        
        //Invalid Email Address
        if !CommonMethods().isValidEmail(testStr: email) {
            showAlert("Email Address", message: "Invalid Email address format",buttonTitle: "Ok")
            return
        }
        
        //passwords don't match
        if pass != cpass {
            showAlert("Password", message: "Password and Confirmed Passowrd won't match" ,buttonTitle: "Ok")
            return
        }
        let parameters: Parameters = [
            "fname": "\(userName)",
            "lname": "\(userName)",
            "email": "\(email)",
            "phone": "\(phone)",
            "password": "\(pass)"
        ]
        
        RegisterUser.resisterNewUser(params: parameters, success: {
            (JSONResponse) -> Void in
            let fname = JSONResponse["fname"].stringValue
            let lname = JSONResponse["lname"].stringValue
            let email = JSONResponse["email"].stringValue
            let phone = JSONResponse["phone"].stringValue
            
            
            self.userInfo.fname = fname
            self.userInfo.lname = lname
            self.userInfo.email = email
            self.userInfo.phone = phone
            
            UserDefaults.standard.set(true, forKey: "RegisterByMail")
            UserDefaults.standard.synchronize()

            self.registerUser()
        }) {
            (error) -> Void in
            showAlert(kAlertTitleCommon, message: kAlertMessageInvalidCredential, buttonTitle: kAlertButtonOk)
        }
        
//        callTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.registerUser), userInfo: nil, repeats: false)
    }
    
    @IBAction func onTapBack(_ sender: Any) {
      _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UI Helper
    func registerUser(){
//        EZAlertController.alert("Success", message: "You have successfully registered. Please Login to continue.", acceptMessage: "OK") { () -> () in
//            self.performSegue(withIdentifier: SegueIdentifiers.unwindSignUpToLogin, sender: self)
        showAlert("Success", message: "You have successfully registered. Please Login to continue.", buttonTitle: "Ok")

      _ =  self.navigationController?.popViewController(animated: true)
     //        }
    }
    
    //MARK: UITextField delegate
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        let numberOnly = NSCharacterSet.init(charactersIn: "0123456789")
//        let stringFromTextField = NSCharacterSet.init(charactersIn: string)
//        let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
//        
//        if textField == txtFieldPhone && strValid {
//            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            return checkEnglishPhoneNumberFormat(string: string, str: str)
//        }
//        else
//        {
//            return true
//        }
//    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.characters.count < 3{
            
            if str!.characters.count == 1{
                
                txtFieldPhone.text = "("
            }
            
        }else if str!.characters.count == 5{
            
            txtFieldPhone.text = txtFieldPhone.text! + ") "
            
        }else if str!.characters.count == 10{
            
            txtFieldPhone.text = txtFieldPhone.text! + "-"
            
        }else if str!.characters.count > 14{
            
            return false
        }
        
        return true
    }

    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SegueIdentifiers.presentDashboard {
//            let navController = segue.destination as! UINavigationController
//           let dashboardVC = navController.topViewController as! DashboardVC
//            dashboardVC.userInfo = self.userInfo
//        }
    }

    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

