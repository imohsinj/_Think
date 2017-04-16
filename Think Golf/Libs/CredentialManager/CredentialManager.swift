//
//  CredentialManager.swift
//  VogCalegory
//
//  Created by Mohsin Jamadar on 9/24/15.
//  Copyright (c) 2017 MJ. All rights reserved.
//

import Foundation

class CredentialManager {
    static let sharedInstance: CredentialManager = CredentialManager()
    
    var email: String?
    var accessToken: String?
    var expires: Date?
    var userId: String?
    var oldPwd: String?
    fileprivate init() {
        
    }
    
    func expired() -> Bool {
        return false
    }
    
    func clearAuthorization() {
        self.email = nil
        self.accessToken = nil
        self.expires = nil
        self.userId = nil
        self.oldPwd = nil
    }
}
