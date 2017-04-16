//
//  CommonMethods.swift
//  VogCalegory
//
//  Created by Reemberto Parada on 5/29/15.
//  Copyright (c) 2017 MJ. All rights reserved.
//

import UIKit

class CommonMethods: NSObject,UIPopoverPresentationControllerDelegate {
 
    var queryString:NSString = NSString()
    var credentials:[String]?
    
    func hasConnectivity() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    
    //Method to check for connectivity
    func CheckForConnectivity() ->Bool
    {
        if !hasConnectivity()
        {
            let message = "It seems you have lost\nyour internet connection\n\nPlease, check your device\nsettings or contact your \nadministrator."
            showAlert("Attention", message: message as String, buttonTitle: "Close")
            return false
        }
        return true
    }
    
    //Validate  an Email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //Save the user name and passworod to the KeyChain
    func SaveUsernameAndPasswordToKeyChain(_ userName:NSString, passWord:NSString) -> Bool
    {
        var saveSuccessfully:Bool = KeychainWrapper.setString(userName as String, forKey: "VogCalegoryusername")
        if saveSuccessfully
        {
            saveSuccessfully = KeychainWrapper.setString(passWord as String, forKey: "VogCalegorypassword")
        }
        return saveSuccessfully
    }
    
    
    //Retreive user name and password from KeyChain
    func RetreiveUserNameAndPasswordFromKeyChain() -> Array<String>
    {
        
        var Credentials:Array = Array<String>()
        let userNameString:String = KeychainWrapper.stringForKey("VogCalegoryusername")!
        let userPwdString:String    = KeychainWrapper.stringForKey("VogCalegorypassword")!
        
        if userNameString != "" && userPwdString != ""
        {
            Credentials = Array(arrayLiteral: userNameString,userPwdString)
            return Credentials
        }
        return Credentials
    }
     
    //Remove the username and password after the session ends
    func DeleteUserNameAndPasswordFromKeyChain() {
        KeychainWrapper.removeObjectForKey("VogCalegoryusername")
        KeychainWrapper.removeObjectForKey("VogCalegorypassword")
    }
    
    //Store the session token in the keychain
    func StoreKeyInKeyChain(_ keyName:String, keyvalue:String)
    {
        KeychainWrapper.setString(keyvalue, forKey: keyName)
    }
    
    
    func RetreiveApplicationGuid() -> NSString?
    {
        return RetriveKeyFromKeyChain("user_guid")
    }
    
    func RetriveKeyFromKeyChain(_ keyName: NSString) -> NSString? {
        let keyValue = KeychainWrapper.stringForKey(keyName as String)
        if let v = keyValue {
            return v as NSString?
        }
        return nil
    }
    
    //Delete the Token from the Key Chain
    func DeleteKeyFromKeyChain(_ keyName:String)->Bool
    {
        let successRemoveToken:Bool = KeychainWrapper.removeObjectForKey(keyName)
        return successRemoveToken
    }
   
    
    /**********************************************************
    METHOD: ConvertNsDateToSQLDate
    ***********************************************************
    Creates an MutableDictionary representation of the object
    to be send via Json.
    **********************************************************/
    func ConvertNSDateToSQLDate(_ stringdate:String)-> NSMutableString
    {
        let converteddate:Date = StringDateToNSDate(stringdate)
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
        let timezone:TimeZone = TimeZone(identifier:  "US/Eastern")!
        dateFormatter.timeZone = timezone
        let sqlDate:NSString = dateFormatter.string(from: converteddate) as NSString
        return sqlDate.mutableCopy() as! NSMutableString
        
    }
    
    func ConvertNSDateToStringDate(_ date:Date)-> String
    {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy";
        let timezone:TimeZone = TimeZone(identifier:  "US/Eastern")!
        dateFormatter.timeZone = timezone
        let sqlDate:NSString = dateFormatter.string(from: date) as NSString
        return sqlDate.mutableCopy() as! NSMutableString as String
        
    }
    
    /*********************************************************
    METHOD: StringDateToNSDate
    **********************************************************
    Convert String Date to NSDate
    *********************************************************/
    func StringDateToNSDate(_ stringDate:String) -> Date
    {
//        print(stringDate)
        var  dateNotFormatted:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat =   "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        if let d = dateFormatter.date(from: stringDate) {
            dateNotFormatted = d
        }
        return dateNotFormatted
    }
    
        //Converts a string date to NSDAte and then returns the Time Portion in local time
    func StringSQLDateToStringTime(_ apptDate:Date) -> String
    {
        let timeFormatter:DateFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let appttime:String = timeFormatter.string(from: apptDate) as String!
        return appttime
    }
    
    
    func getNameOfMonth(_ appointmentDate:Date)-> String {
        
        let nameOfTheMonths:NSMutableArray = NSMutableArray()
        nameOfTheMonths.add("Jan")
        nameOfTheMonths.add( "Feb")
        nameOfTheMonths.add("Mar")
        nameOfTheMonths.add("Apr")
        nameOfTheMonths.add("May")
        nameOfTheMonths.add("Jun")
        nameOfTheMonths.add("Jul")
        nameOfTheMonths.add("Aug")
        nameOfTheMonths.add("Sep")
        nameOfTheMonths.add("Oct")
        nameOfTheMonths.add("Nov")
        nameOfTheMonths.add("Dec")
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let myCalendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.month, from: appointmentDate)
        let monthnumber:Int = myComponents.month!
        
        return nameOfTheMonths.object(at: monthnumber-1) as! String
    }
    
    func getNumberOfMonth(_ appointmentDate:Date)-> String {
        
        let nameOfTheMonths:NSMutableArray = NSMutableArray()
        nameOfTheMonths.add("1")
        nameOfTheMonths.add( "2")
        nameOfTheMonths.add("3")
        nameOfTheMonths.add("4")
        nameOfTheMonths.add("5")
        nameOfTheMonths.add("6")
        nameOfTheMonths.add("7")
        nameOfTheMonths.add("8")
        nameOfTheMonths.add("9")
        nameOfTheMonths.add("10")
        nameOfTheMonths.add("11")
        nameOfTheMonths.add("12")
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let myCalendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.month, from: appointmentDate)
        let monthnumber:Int = myComponents.month!
        
        return nameOfTheMonths.object(at: monthnumber-1) as! String
    }
    
    
    func getDayOfMonth(_ appointmentDate:Date)-> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let myCalendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.day, from: appointmentDate)
        let dayNumber:Int = myComponents.day!
        
        return "\(dayNumber)"
    }
    
    func getYear(_ appointmentDate:Date)-> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let myCalendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.year, from: appointmentDate)
        let yearNumber:Int = myComponents.year!
        
        return "\(yearNumber)"
    }
    
    /*********************************************************
    METHOD: StringDateToNSDate
    **********************************************************
    Convert String Date to NSDate
    *********************************************************/
    func SQLDateToStringDate(_ stringDate:String) -> String
    {
//        print(stringDate)
        var  dateNotFormatted:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat =   "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        if let convertedDate = dateFormatter.date(from: stringDate) {
            dateNotFormatted = convertedDate
        }
        
        //Get the year, month and day
        let year:Int = getCalendarComponent(dateNotFormatted).year!
        let month:Int = getCalendarComponent(dateNotFormatted).month!
        let day:Int = getCalendarComponent(dateNotFormatted).day!
        
        //Convert it to date
        return "\(month)-\(day)-\(year)"
    }
    
    func getCalendarComponent(_ date:Date) -> DateComponents
    {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute, .month, .year, .day], from: date)
        
        return components
    }
    
       
   }

