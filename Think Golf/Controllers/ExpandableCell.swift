//
//  ExpandableCell.swift
//  ThinkGolf
//
//  Created by utkarsha ankalkote on 15/04/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import Foundation

class ExpandableCell: UITableViewCell {
    
    
    @IBOutlet weak var imgHeaderBg: UIImageView!
    @IBOutlet weak var imgSessionTitle: UIImageView!
    @IBOutlet weak var lblSessionTitle: UILabel!
    @IBOutlet weak var imgHeaderBottom: UIImageView!
    @IBOutlet weak var imgCellBottom: UIImageView!
    @IBOutlet weak var imgSessionDetails: UIImageView!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    
    
    @IBOutlet weak var viewStartTut: UIView!
    
    
    //        @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    
    //MARK: Public variables
    var isObserving = false;
    class var expandedHeight: CGFloat { get { return 160 } }
    class var defaultHeight: CGFloat  { get { return 64  } }

    // MARK: - Expand Collapse Helpers
    func checkHeight() {
        viewDetails.isHidden = (frame.size.height < ExpandableCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    @objc
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }

    }
    
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.imgHeightConstraint.constant = 0.0
                imgCellBottom.isHidden = false
                imgHeaderBottom.isHidden = true
                
            } else {
                self.imgHeightConstraint.constant = 106.0
                imgCellBottom.isHidden = true
                imgHeaderBottom.isHidden = false
                
                
            }
        }
    }
    
    
    
}
