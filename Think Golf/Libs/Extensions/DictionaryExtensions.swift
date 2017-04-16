//
//  DictionaryExtensions.swift
//  VogCalegory
//
//  Created by Mohsin on 9/4/15.
//  Copyright (c) 2017 MJ. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func toEncodedQueryParamString() -> String? {
        if self.count == 0 {
            return nil
        }
        
        let result = NSMutableArray()
        for (k, v) in self {
            if let key = k as? String {
                if let value = v as? String {
//                    let urlEncodedValue = value.urlEncode()
//                    if let u = urlEncodedValue {
                        let resultString = String(format: "%@=%@", key, value)
                        result.add(resultString)
//                    }
                }
            }
        }
        
        return result.componentsJoined(by: "&")
    }
}
