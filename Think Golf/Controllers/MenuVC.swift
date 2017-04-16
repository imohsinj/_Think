//
//  MenuVC.swift
//  ThinkGolf
//
//  Created by Mohsin Jamadar on 26/03/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import Foundation

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgViewMenu: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

protocol MenuVCDelegate{
    func didTapOnIndex(index:Int)
    func didTapOnLogout()
}

class MenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // data array
    var arrayTitles = ["Profile","Add Contact","Restore Purchases","Subscription","Help"]
    var arrayImage = ["menu_profile icon","menu_add contact icon","menu_restore purchase icon","menu_subscription icon","menu_help icon"]
    
    var delegate:MenuVCDelegate! = nil
    var userInfo : UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSideMenu()
    }
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        SideMenuManager.menuWidth = max(round(min((self.view.frame.width), (self.view.frame.height)) * 0.85), 240)
        SideMenuManager.menuPresentMode = .menuSlideIn

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBAction
     @IBAction func onTapLogout(_ sender: Any) {
        self.delegate.didTapOnLogout()
    }
    
    // MARK: TableView Data source methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.selectionStyle = .none
        cell.lblTitle.text = arrayTitles[indexPath.row]
        cell.imgViewMenu.image =   UIImage(named:arrayImage[indexPath.row])!

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        switch indexPath.row {
        case 0:
            if let profileVC = storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC{
                profileVC.userInfo = self.userInfo
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            break
        default:
            showAlert("Think Golf", message: "In progress", buttonTitle: "Ok")
            break
            
        }
    }
}
