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
    var sectionName: String
    var sectionObject : [Attributs]
    
}

struct Attributs{
    var city: String?
    var airportName: String?
    var code : String
}


class Parser{
    func prepareDataForDisplay(objects: [AirportInfo]) -> [SheduleInfoToDisplay]{
        var shedule =  [SheduleInfoToDisplay]()
        
        
        for airport in objects{
            shedule.append(SheduleInfoToDisplay(isOpen: false, sectionName: airport.country,
                                                sectionObject: [Attributs(city: airport.city ?? "", airportName: airport.name ?? "", code: airport.code)] ))
        }
        
//        shedule.reduce([SheduleInfoToDisplay]()) { (prev, new) in
//            for i in 0..<prev.count{
//                if prev[i].sectionName == new.sectionName{
//                    SheduleInfoToDisplay(isOpen: false,  sectionName: prev[i].sectionName, sectionObject: prev[i].sectionObject + new.sectionObject)
//                }
//            }
//            return prev
//        }
        
        var sheduleForDisplay = [SheduleInfoToDisplay]()
        
        let size  = shedule.count
        for i in 0..<size{
            for j in i..<size{
                if shedule[i].sectionName == shedule[j].sectionName{
                    sheduleForDisplay.append(SheduleInfoToDisplay(isOpen: false,  sectionName: shedule[i].sectionName, sectionObject: shedule[i].sectionObject + shedule[j].sectionObject))
                }
                }
            }
        
        return sheduleForDisplay
    }
}
