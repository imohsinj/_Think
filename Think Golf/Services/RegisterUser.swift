//
//  RegisterUser.swift
//  ThinkGolf
//
//  Created by Mohsin Jamadar on 25/03/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegisterUser: NSObject {
    class func resisterNewUser(params : [String: Any]?,success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        let URL =  "http://52.60.147.19/golf/api/usersignup.php"
        AFWrapper.requestPOSTURL(URL, params: params, headers: nil, success: {
            (JSONResponse) -> Void in
             success(JSONResponse)
        }) {
            (error) -> Void in
            failure(error)
        }
    }

    
    
    
}
