//
//  ConfigurationManager.swift
//  VogCalegory
//
//  Created by Mohsin Jamadar on 9/16/15.
//  Copyright (c) 2017 MJ. All rights reserved.
//

import Foundation

enum EnvironmentType : String {
    case Dev = "Dev"
}

/**
 *  Singleton to manage Config settings for the app.
 *  Quick Note: Uses force casts (!) in cases where the application cannot function if the values are not present.
 *  In that case, it's probably better to crash than silently fail elsewhere.
 */
open class ConfigurationManager : NSObject {
    
    static let schemePlistKey = "Scheme"
    static let baseUrlPlistKey = "BaseUrl"
    static let relativePathPlistKey = "RelativePath"
    static let plistName = "URLConfig"
    static let apiUrlKey = "API"
    static let termsOfUseKey = "TermsOfUse"

    static let sharedInstance = ConfigurationManager()

    fileprivate var urlConfiguration: NSDictionary?
    fileprivate var environmentType: EnvironmentType
    
    fileprivate override init() {
        self.environmentType = .Dev
    }
    
    func currentEnvironment() -> EnvironmentType {
        return environmentType
    }
    
    
    func baseUrlComponents() -> Dictionary<String, String> {
        return self.urlComponentsFromConfig(currentEnvironment(), type: ConfigurationManager.apiUrlKey)
    }
    
    // TODO: Ugly, but have to do this for backwards compat purposes.
    // Maybe clean up the plist format in the future.
    func baseUrl() -> String {
        return stringUrlFromComponents(self.baseUrlComponents())
    }
    
    func stringUrlFromComponents(_ components: Dictionary<String, String>) -> String {
        let scheme = components[ConfigurationManager.schemePlistKey]!
        let baseUrl = components[ConfigurationManager.baseUrlPlistKey]!
        let relativePathKey = components[ConfigurationManager.relativePathPlistKey]
        var url = scheme + "://" + baseUrl
        if let r = relativePathKey {
            url = url + r
        }
        return url
    }
    
    func urlComponentsFromConfig(_ environmentType: EnvironmentType, type: String) -> Dictionary<String, String> {
        let config = urlConfigurationDict()
        return (config.object(forKey:environmentType.rawValue) as AnyObject).object(forKey:type) as! Dictionary<String, String>

    }
    
    func urlConfigurationDict() -> NSDictionary {
        if urlConfiguration == nil {
            let path = Bundle.main.path(forResource: ConfigurationManager.plistName, ofType: "plist")
            urlConfiguration = NSDictionary(contentsOf: URL(fileURLWithPath: path!) as URL)
        }
        
        return urlConfiguration!
    }
}
