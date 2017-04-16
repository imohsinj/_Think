//
//  ValidatingTextField.swift
//  VogCalegory
//
//  Created by Mohsin Jamadar on 10/23/15.
//  Copyright © 2015 VogCalegory. All rights reserved.
//

import Foundation
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

class ValidatingTextField : UITextField {
    
    enum ValidationType {
        case Phone, NumericOnly, AlphaOnly, Name
    }
    
    var required = false
    var maximumLength: Int = Int.max
    var minimumLength: Int = 0
    
    // Specify only one of the two below (ValidationType / RegEx)
    // If both are specified, we use the regex specified
    var validationType: ValidationType?
    var regEx: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        self.addTarget(self, action: #selector(ValidatingTextField.valueChanged), for: UIControlEvents.editingChanged)
        self.rightViewMode = UITextFieldViewMode.always
        self.rightView = UIView(frame: CGRect (self.bounds.width - 10.0, 0.0, 10.0, self.frame.height))
        self.rightView?.backgroundColor = UIColor.clear
    }
    
    func valueChanged() {
        if self.valid() {
            self.markValid()
        }
        else {
            self.markInvalid()
        }
    }

    func valid() -> Bool {
        if (self.required && (self.text == nil || self.text!.isEmpty)) {
            self.markInvalid()
            return false
        }
        
        if self.text!.characters.count > maximumLength || self.text!.characters.count < minimumLength {
            self.markInvalid()
            return false
        }
        
        if let v = validationType {
            self.regEx = self.regEx1(validationType: v)
        }
        
        if let r = self.regEx {
            let text = (self.text != nil) ? self.text : ""
            
            let result = text?.range(of:r, options:.regularExpression)
            if !(result != nil) {
                self.markInvalid()
            }
            return (result != nil)
        }

        return true
    }
    
    func regEx1(validationType: ValidationType) -> String {
        switch validationType {
        case .AlphaOnly:
            return "^[a-zA-Z]*$"
        case .NumericOnly:
            return "^[0-9]*$"
        case .Name:
            return "([a-z]+[,.]?[ ]?|[a-z]+['-]?)*"
        case .Phone:
            return "^\\(?([2-9][0-8][0-9])\\)?[-. ]?([2-9][0-9]{2})[-. ]?([0-9]{4})$"
        }
    }
    
    func markInvalid() {
        self.backgroundColor = UIColor( red: 254/255, green: 227/255, blue:229/255, alpha: 1.0 )
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.0

        //Add asterisk in rightview
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 18))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        label.font = UIFont(name: "OpenSans-SemiBold", size: 28.0)
        label.text = "*"
        label.textColor = UIColor.red
        label.contentMode = UIViewContentMode.center
        rightView.addSubview(label)
        self.rightView = rightView
        
        //Apply red color to placeholder
        if self.placeholder != nil {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                            attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
    }
    
    func markValid() {
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.white.cgColor
        self.rightView = nil
        //Reset color of placeholder
        if self.placeholder != nil {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                            attributes: [NSForegroundColorAttributeName: UIColor( red: 199/255, green: 199/255, blue:205/255, alpha: 1.0 )])
        }

    }
}
