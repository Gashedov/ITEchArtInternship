//
//  DateManager.swift
//  AirportShedule
//
//  Created by student on 4/18/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

class DateManager
{
    
    func getTime()->(begin: Int, end: Int){
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        let dayInterval = 24*60*60-1.0
        let startOfDay = calendar.startOfDay(for: Date()).timeIntervalSince1970
        
        let endOfRequest = startOfDay + dayInterval
        let startOfRequest = endOfRequest - dayInterval*3
        
        return (begin: startOfRequest.toInt() ?? 0, end:  endOfRequest.toInt() ?? 0)
        
    }
    
    func convertToDate(time: Int)-> (Date,Date){
        return (Date(),Date())
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
