//
//  MenuVC.swift
//  ThinkGolf
//
//  Created by Mohsin Jamadar on 26/03/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import Foundation

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldValue: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

protocol ProfileVCDelegate{
    func didTapOnLogout()
}

class ProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // data array
    var arrayTitles = ["Name","Member Since","Email","Password"]
    var userInfo : UserInfo?
    
    @IBOutlet weak var imgViewUserProfile: UIImageView!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnLinkedIn: UIButton!
    @IBOutlet weak var viewConnectedAccounts: UIView!
    
    var delegate:ProfileVCDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        prepareProfileImage()
        checkForLoginSession()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareProfileImage(){
        imgViewUserProfile.layoutIfNeeded()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.selectProfileImage))
        gestureRecognizer.numberOfTapsRequired = 1

        imgViewUserProfile.isUserInteractionEnabled = true
        let square = imgViewUserProfile.frame.size.width < imgViewUserProfile.frame.height ? CGSize(width: imgViewUserProfile.frame.size.width, height: imgViewUserProfile.frame.size.width) : CGSize(width: imgViewUserProfile.frame.size.height, height:  imgViewUserProfile.frame.size.height)
        imgViewUserProfile.addGestureRecognizer(gestureRecognizer)
        imgViewUserProfile.layer.cornerRadius = square.width/2
        imgViewUserProfile.clipsToBounds = true;
    }
    
    func checkForLoginSession(){
        viewConnectedAccounts.isHidden = true
        if UserDefaults.standard.object(forKey: "LIAccessToken") != nil {
            viewConnectedAccounts.isHidden = false
            btnLinkedIn.isHidden = false
            btnFacebook.isHidden = true
        }
        else if UserDefaults.standard.object(forKey: "FBAccessToken") != nil {
            viewConnectedAccounts.isHidden = false
            btnLinkedIn.isHidden = true
            btnFacebook.isHidden = false
        }
    }
    
    func selectProfileImage() {
    
    }
    
    // MARK: IBAction
     @IBAction func onTapEdit(_ sender: Any) {
        showAlert("Think Golf", message: "In progress", buttonTitle: "Ok")
    }
    
    @IBAction func onTapBack(_ sender: Any) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onTapFacebookLogOut(_ sender: Any) {
        
    }
    
    @IBAction func onTapLinkedInLogOut(_ sender: Any) {
        
    }

    // MARK: TableView Data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.lblTitle.text = arrayTitles[indexPath.row]

        switch indexPath.row {
        case 0:
            if (self.userInfo?.fname?.characters.count)! > 0 {
                cell.txtFieldValue.text = (userInfo?.fname)! + " " + (userInfo?.lname)!
            }
            break
        case 2:
            if (self.userInfo?.email?.characters.count)! > 0 {
                cell.txtFieldValue.text = userInfo?.email
            }
            break
        case 3:
                cell.txtFieldValue.text = "*****"
            break

        default:
            cell.txtFieldValue.text = "-"
        }
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitles.count
    }
}
