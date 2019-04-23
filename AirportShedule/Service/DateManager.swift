//
//  DateManager.swift
//  AirportShedule
//
//  Created by student on 4/18/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

class DateManager {
    
    private let dayInterval = 24*60*60-1
    
    init() {
    }
    
    func getTime()->(begin: Int, end: Int) {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let startOfDay = calendar.startOfDay(for: Date()).timeIntervalSince1970.toInt() ?? 0
        
        let endOfRequest = startOfDay + dayInterval
        let startOfRequest = endOfRequest - dayInterval*3
        
        return (begin: startOfRequest, end:  endOfRequest)
        
    }
    
    func convertTimeToString(time: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: Double(time))
        
        return dateFormatter.string(from: date)
    }
    
    func convertDateToString(time: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let date = Date(timeIntervalSince1970: Double(time))
        
        return dateFormatter.string(from: date)
    }
    
}

extension Double {
    func toInt() -> Int? {
        if self > Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
