//
//  Parser.swift
//  AirportTimetable
//
//  Created by student on 3/26/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct SheduleInfoToDisplay{
    var isOpen: Bool
    var sectionName: String?
    var sectionObject : [String]?
    
}

class Parser{
    func prepareDataForDisplay(objects: [AirportInfo]) -> [SheduleInfoToDisplay]{
        var shedule =  [SheduleInfoToDisplay]()
        for airport in objects{
            shedule.append(SheduleInfoToDisplay(isOpen: false, sectionName: airport.country,sectionObject: [airport.name, airport.city ?? "", airport.code] ))
        }
        return shedule
    }
}
