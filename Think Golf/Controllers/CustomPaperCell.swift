//
//  CustomPaperCell.swift
//  PaperView
//
//  Created by Adam J Share on 3/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import PaperCollectionView


class CustomPaperCell: PaperCell {
    
    var contentVC: ContentViewController?
    
    
}

class ContentViewController: UIViewController, PaperCellChangeDelegate {
    
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    @IBOutlet weak var baseContentView: UIView!
    @IBOutlet weak var roundedView: UIView!
    
    func presentationRatio(_ ratio: CGFloat) {
//        bigLabel.alpha = 1 - ratio
//        smallLabel.alpha = ratio
//        descriptionTitleLabel.alpha = ratio
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//baseContentView.layer.shadowColor = UIColor.black.cgColor
//baseContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//baseContentView.layer.shadowOpacity = 0.2
//baseContentView.layer.shadowRadius = 2
//roundedView.layer.cornerRadius = 4
//roundedView.clipsToBounds = true
    }
}
