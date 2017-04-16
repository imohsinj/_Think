//
//  DateExtension.swift
//  VogCalegory
//
//  Created by Mohsin Jamadar on 9/2/15.
//  Copyright (c) 2017 MJ. All rights reserved.
//

import Foundation
let apiDateFormats = [ "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss'.'SSS" ]

extension Date  {
        
    func sameDay(_ anotherDate: Date) -> Bool {
        let currentComponents = (Calendar.current as NSCalendar).components([.day, .month, .year], from: self)
        let targetComponents = (Calendar.current as NSCalendar).components([.day, .month, .year], from: self)
        
        return (currentComponents.day == targetComponents.day && currentComponents.month == targetComponents.month && currentComponents.year == targetComponents.year)
    }
    
    func addDays(_ count: Int) -> Date? {
        var component = DateComponents()
        component.day = count
        return (Calendar.current as NSCalendar).date(byAdding: component, to: self, options: NSCalendar.Options(rawValue: 0))
    }
    
    func addMinutes(_ count: Int) -> Date? {
        var component = DateComponents()
        component.minute = count
        return (Calendar.current as NSCalendar).date(byAdding: component, to: self, options: NSCalendar.Options(rawValue: 0))
    }
    
    func addSeconds(_ count: Int) -> Date? {
        var component = DateComponents()
        component.second = count
        return (Calendar.current as NSCalendar).date(byAdding: component, to: self, options: NSCalendar.Options(rawValue: 0))
    }
    
    func addYears(_ yearCount: Int) -> Date? {
        var component = DateComponents()
        component.year = yearCount
        return (Calendar.current as NSCalendar).date(byAdding: component, to: self, options: NSCalendar.Options(rawValue: 0))
    }
    
    static func ageFromDateOfBirth(_ dateTxt: String, format: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateTxt) {
            let dateComponents = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: date, to: Date(), options: NSCalendar.Options(rawValue: 0))
            return dateComponents.year
        }
        return nil
    }

    static func fromFormat(_ format: String, date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }
    
    static func toFormat(_ format: String, date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    
    static func toApiDateFormat(_ date: Date) -> String? {
        return Date.toFormat(apiDateFormats[0], date: date)
    }
    
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func shortMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func getDayOfTheWeek() -> String? {
        let weekDaysArray = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: self)
        return weekDaysArray[myComponents.weekday! - 1]
    }

    func dateValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    func shortDayName() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayOfWeekString = dateFormatter.string(from: self)
        return dayOfWeekString
    }
    
      
    func startOfDay() -> Date {
        let calendar = Calendar.current
        var dateComponents = (calendar as NSCalendar).components(([.year, .month, .day, .hour, .minute, .second]), from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return calendar.date(from: dateComponents)!
    }
    
    func currentDay() -> Date {
        let calendar = Calendar.current
        var dateComponents = (calendar as NSCalendar).components(([.year, .month, .day, .hour, .minute, .second]), from: self)
        dateComponents.minute = 0
        dateComponents.second = 0
        return calendar.date(from: dateComponents)!
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar.current
        var dateComponents = (calendar as NSCalendar).components(([.year, .month, .day, .hour, .minute, .second]), from: self)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        return calendar.date(from: dateComponents)!
    }
    
    func isFuture() -> Bool {
        return (self.compare(Date()) == ComparisonResult.orderedDescending)
    }

    //calculate remaining hours of a date
    func remainingHours() -> Int{
        let endDate = self.endOfDay()
        let dayHourMinuteSecond: NSCalendar.Unit = [.day,.hour,.minute,.second]
        
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(identifier:  "US/Eastern")!
        let difference = (cal as NSCalendar).components(
            dayHourMinuteSecond,
            from: self,
            to: endDate,
            options: [])
        let strHours = String(format: "%d", difference.hour!)
        let remainingHours = Int(strHours)!
        return remainingHours
    }

    
    func printLocalTime() {
//        let locale = NSLocale.currentLocale()
//        print(self.descriptionWithLocale(locale))
    }
}

public func ==(lhs: Date, rhs:Date) -> Bool {
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}

public func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}

public func <= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}

public func >= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
