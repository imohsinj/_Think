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
import SVProgressHUD
import Alamofire
import FBSDKLoginKit
import SwiftyJSON

extension DefaultsKeys {
    static let isFirstTimeLaunched = DefaultsKey<Bool?>("isFirstTimeLaunched")
}


class LoginVC: UIViewController, BWWalkthroughViewControllerDelegate {

    //Outlets
    @IBOutlet weak var txtFieldUsername: ValidatingTextField!
    @IBOutlet weak var txtFieldPass: ValidatingTextField!
    
    @IBOutlet weak var btnSingUp: UIButton!
    //iVars
     var callTimer: Timer!
        var userInfo: UserInfo?
        var isLinkedInAccess = false
    
    let yourAttributes : [String: Any] = [
        NSFontAttributeName :  UIFont(name: "CenturyGothic", size: 17.0) as Any,
        NSForegroundColorAttributeName : UIColor.white,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after lvaring the view, typically from a nib.
        prepareUI()
        setupTextFieldValidation()
//        checkIntro() //TODO:UNCOMMENT
        registerTempDataPopulater()
         checkForExistingAccessToken()
    }
    
    func registerTempDataPopulater() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.autoLogin))
        gestureRecognizer.numberOfTapsRequired = 3
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func autoLogin(){
        txtFieldUsername.text = "mj@mj.com"
        txtFieldPass.text = "mj"
        onTapLogin(UIButton())
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIntro()
        if isLinkedInAccess{
            isLinkedInAccess = false
            checkForExistingAccessToken()
        }
    }

    func prepareUI(){
        txtFieldUsername.layer.borderWidth = 1.0
        txtFieldUsername.layer.borderColor = UIColor.white.cgColor
        txtFieldPass.layer.borderWidth = 1.0
        txtFieldPass.layer.borderColor = UIColor.white.cgColor
        
        let attributeString = NSMutableAttributedString(string: "Don't have an Account? Sign Up",                                             attributes: yourAttributes)
        btnSingUp.setAttributedTitle(attributeString, for: .normal)

    }
 
    // MARK: - Walkthrough
    func checkIntro(){
          let userDefaults = UserDefaults.standard
          if !userDefaults.bool(forKey: "isFirstTimeLaunched") {
            UserDefaults.standard.set(true, forKey: "isFirstTimeLaunched")
            UserDefaults.standard.synchronize()
            displayIntro()
        }
    }

    func displayIntro(){
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_zero)
        
        self.present(walkthrough, animated: true, completion: nil)

    }
    
    // MARK: - Event Listeners
    @IBAction func onTapLogin(_ sender: UIButton) {
        if !self.validate() {
            showAlert(kAlertTitleCommon, message: "Please fill in all required fields.", buttonTitle: "Ok")
            return
        }
        
        let userName = txtFieldUsername.text!;
        let pass = txtFieldPass.text!;
        
        let parameters: Parameters = [
            "email": "\(userName)",
            "password": "\(pass)"
        ]
        
        let URL =  "http://52.60.147.19/golf/api/login.php"
        AFWrapper.requestPOSTURL(URL, params: parameters, headers: nil, success: {
            (JSONResponse) -> Void in
            
            self.createUserObject(data: JSONResponse)
            
            self.txtFieldUsername.text = ""
            self.txtFieldPass.text = ""

//            UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: "RegisterByMail")
//            UserDefaults.standard.synchronize()
//            UserDefaults.standard.set(JSONResponse["email"].stringValue, forKey: "user")
//            UserDefaults.standard.synchronize()
//            UserDefaults.standard.set(JSONResponse["pass"].stringValue, forKey: "pass")
//            UserDefaults.standard.synchronize()

            self.login()
        }) {
            (error) -> Void in
            showAlert(kAlertTitleCommon, message: kAlertMessageInvalidCredential, buttonTitle: kAlertButtonOk)
        }
        
//            AFWrapper.requestGETURL(strURL, success: {
//                (JSONResponse) -> Void in
//                print(JSONResponse)
//            }) {
//                (error) -> Void in
//                print(error)
//        }
//    }
        
    }
    
    
    @IBAction func onTapFacebook(_ sender: Any) {
//        showSpinner("Please wait...")
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email","user_friends"], from: self, handler: { (result, error) -> Void in
            if (error == nil){
                let _ : FBSDKLoginManagerLoginResult = result!
                self.getFBUserData()
            }
            else
            {
                 dismissSpinner()
                showAlert("Warning!", message: "Try after some time.", buttonTitle: "Ok")
            }
        })
    }
    
    @IBAction func onTapLinkedin(_ sender: Any) {
    }
    
    @IBAction func onTapSignup(_ sender: Any) {
    }
    
    @IBAction func onTapForgotPass(_ sender: Any) {
    }
    
    
    //MARK:- FB Login
    func getFBUserData()
    {
        if (FBSDKAccessToken.current() != nil)
        {
            
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields":"first_name, last_name, picture.type(large),email,gender,name"])
            
            // Send request to Facebook
            _ = request?.start
                {
                    
                    (connection, result, error) in
                    
                    if error != nil
                    {   dismissSpinner()
                        showAlert("Alert", message: "Error while loging...", buttonTitle: "Ok")
                        // Some error checking here
                    }
                        
                    else if (result as? [String:AnyObject]) != nil
                    {
                        //  Processcall.hideLoadingWithView()
                        print("FB Data: \(result)")
                        UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: "FBAccessToken")
                        UserDefaults.standard.synchronize()
                        self.linkFBUserAccount(result: result as! [String : AnyObject])
                    }
            }
        }
        else
        {
            print("GO TO SIGNN IN VIEW")
            dismissSpinner()
        }
    }
    func linkFBUserAccount(result:[String:AnyObject])
    {
        var fname = ""
        var lname = ""
        var email = ""
        var facebook_id = ""
        var linkedIn_id = ""
        
        if let fname1 = result["first_name"] as? String {
            // no error
            fname = fname1
        }

        if let lname1 = result["last_name"] as? String {
            // no error
            lname = lname1
        }
        
        if let email1 = result["email"] as? String {
            // no error
            email = email1
        }
        
        if let facebook_id1 = result["id"] as? String {
            // no error
            facebook_id = facebook_id1
        }
        if let linkedIn_id1 = result["id"] as? String {
            // no error
            linkedIn_id = linkedIn_id1
        }


        let parameters: Parameters = [
            "fname": "\(fname)",
            "lname": "\(lname)",
            "email": "\(email)",
            "phone": "",
            "facebook_id": "\(facebook_id)",
            "link_id": "\(linkedIn_id)"
        ]
        
        registerNewUser(params: parameters)
    }
    
    func linkLinkedInUserAccount(result:[String:AnyObject])
    {
        var fname = ""
        var lname = ""
        var email = ""
        var linkedIn_id = ""
        
        if let fname1 = result["firstName"] as? String {
            // no error
            fname = fname1
        }
        
        if let lname1 = result["lastName"] as? String {
            // no error
            lname = lname1
        }
        
        if let email1 = result["emailAddress"] as? String {
            // no error
            email = email1
        }

        if let linkedIn_id1 = result["id"] as? String {
            // no error
            linkedIn_id = linkedIn_id1
        }
        
        
        let parameters: Parameters = [
            "fname": "\(fname)",
            "lname": "\(lname)",
            "email": "\(email)",
            "phone": "",
            "link_id": "\(linkedIn_id)"
        ]
        
        registerNewUser(params: parameters)
    }
    
    func registerNewUser(params : [String: Any]?){
        RegisterUser.resisterNewUser(params: params, success: {
            (JSONResponse) -> Void in
            self.createUserObject(data:JSONResponse)
            self.login()
        }) {
            (error) -> Void in
            showAlert(kAlertTitleCommon, message: kAlertMessageInvalidCredential, buttonTitle: kAlertButtonOk)
        }
    }

    func createUserObject(data:JSON){
        let user_id = data["info"]["id"].stringValue
        let fname = data["info"]["fname"].stringValue
        let lname = data["info"]["lname"].stringValue
        let email = data["info"]["email"].stringValue
        let phone = data["info"]["phone"].stringValue
        
        self.userInfo = UserInfo()
        self.userInfo?.user_id = user_id
        self.userInfo?.fname = fname
        self.userInfo?.lname = lname
        self.userInfo?.email = email
        self.userInfo?.phone = phone

    }
    
    // MARK: Linked Login
    
     func getProfileInfo() {
        if let accessToken = UserDefaults.standard.object(forKey: "LIAccessToken") {
            // Specify the URL string that we'll get the profile info from.
            let targetURLString = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url)?format=json"
            
            // Initialize a mutable URL request object.
            let request = NSMutableURLRequest(url: URL(string: targetURLString)!)
            
            // Indicate that this is a GET request.
            request.httpMethod = "GET"
            
            // Add the access token as an HTTP header field.
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            
            // Initialize a NSURLSession object.
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data,response,error in
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                if statusCode == 200 {
                    // Convert the received JSON data into a dictionary.
                    do {
                        let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        let snapshotValue = dataDictionary as? [String:AnyObject]
                        print("Linked in Data: \(snapshotValue)")
                        self.linkLinkedInUserAccount(result:snapshotValue!)
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
            })
            task.resume()
            
        }
    }
    
     func checkForExistingAccessToken() {
        if UserDefaults.standard.object(forKey: "LIAccessToken") != nil {
            //Direct login
            getProfileInfo()
        }
        else if UserDefaults.standard.object(forKey: "FBAccessToken") != nil {
            getFBUserData()
        }
//        else if UserDefaults.standard.object(forKey: "RegisterByMail") != nil {
//            //Direct login
//            let username =  UserDefaults.standard.object(forKey: "user")
//            let pass = UserDefaults.standard.object(forKey: "pass")
//            txtFieldUsername.text = username as! String?
//            txtFieldPass.text = pass as! String?
//            onTapLogin(UIButton())
//        }
    }

    
    //MARK:- Validations
    func setupTextFieldValidation() {
        self.txtFieldPass.required = true
        self.txtFieldUsername.required = true
    }
    
    func validate() -> Bool {
        var flag = true
        let textFields = [self.txtFieldUsername,self.txtFieldPass]
        for textField in textFields {
            flag = (textField?.valid())! && flag
        }
        return flag
    }
    
    // MARK: - Unwind
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        //        EZAlertController.alert("Success", message: "You have successfully registered. Please Login to continue.", acceptMessage: "OK") { () -> () in
//        showAlert("Success", message: "You have successfully registered. Please Login to continue.", buttonTitle: "Ok")

    }

    
    // MARK: - UI Helper
    func login(){
        self.performSegue(withIdentifier: SegueIdentifiers.presentDashboard, sender: self)
    }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.presentDashboard {
            let navController = segue.destination as! UINavigationController
            let dashboardVC = navController.topViewController as! DashboardVC
            dashboardVC.userInfo = self.userInfo!
        }
        if segue.identifier == SegueIdentifiers.dissmisLinkedIn {
            isLinkedInAccess = true
        }
    }

    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

