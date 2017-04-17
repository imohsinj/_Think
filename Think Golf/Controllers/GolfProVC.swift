//
//  GolfPro.swift
//  ThinkGolf
//
//  Created by Mohsin Jamadar on 17/04/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import Foundation
import PaperCollectionView

class GolfProVC: UIViewController, PaperCellChangeDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableViewSession: UITableView!
    
    let imgsTitle = ["select_clubs_icon", "swing_set_up_icon", "tempo_set_up", "timing_icon", "voice_sounds_icon"]
    let imgsDetails = ["","swing", "tempo", "timing", "voice"]
    
    let titleS = ["Select Clubs","Swing Setup", "Tempo Setup", "Timing", "Voice/Sounds"]
    
    let level = ["","", "Level1", "Level2", "Level3"]
    var indexPathOfSelectedRow : IndexPath?
    
    var expandedRows = Set<Int>()
    
    
    func presentationRatio(_ ratio: CGFloat) {
        //        bigLabel.alpha = 1 - ratio
        //        smallLabel.alpha = ratio
        //        descriptionTitleLabel.alpha = ratio
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSession.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    // TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExpandableCell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell") as! ExpandableCell
        
        //        cell.viewStartTut.isHidden = true
        if (imgsTitle[indexPath.row] != nil || !imgsTitle[indexPath.row].isEmpty ){
            cell.imgSessionTitle.image = UIImage(named: imgsTitle[indexPath.row])
            
        }
        if (imgsDetails[indexPath.row] != nil || !imgsDetails[indexPath.row].isEmpty ){
            cell.imgSessionDetails.image = UIImage(named: imgsDetails[indexPath.row])
            
        }
        if (titleS[indexPath.row] != nil || !titleS[indexPath.row].isEmpty ){
            cell.lblSessionTitle.text = titleS[indexPath.row]
            
        }
        if (level[indexPath.row] != nil || !level[indexPath.row].isEmpty ){
            cell.lblLevel.text = level[indexPath.row]
            
        }
        
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 308.0
    }
    
    
    // MARK: Table view Delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Expand and Collapse logic
        let previousIndexPath = indexPathOfSelectedRow
        if indexPath == indexPathOfSelectedRow {
            indexPathOfSelectedRow = nil
        } else {
            indexPathOfSelectedRow = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = indexPathOfSelectedRow {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths as [IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Clear the background color of cell on de-selection or selecting other cell
        (cell as! ExpandableCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ExpandableCell).ignoreFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Calculate the height for Expand and Collapse
        if indexPath == indexPathOfSelectedRow {
            return ExpandableCell.expandedHeight
        } else {
            return ExpandableCell.defaultHeight
        }
}
}
