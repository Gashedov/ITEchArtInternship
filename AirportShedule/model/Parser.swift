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
    var sectionObject : [Atributs]
    
}

struct Atributs{
    var city: String?
    var airportName: String?
    var code : String
}


class Parser{
    func prepareDataForDisplay(objects: [AirportInfo]) -> [SheduleInfoToDisplay]{
        var shedule =  [SheduleInfoToDisplay]()
        
        
        for airport in objects{
            shedule.append(SheduleInfoToDisplay(isOpen: false, sectionName: airport.country,
                                                sectionObject: [Atributs(city: airport.city ?? "", airportName: airport.name ?? "", code: airport.code)] ))
        }
        
//        shedule.reduce([SheduleInfoToDisplay]()) { (prev, new) in
//            if prev.contains(where: {$0.sectionName == new.sectionName}){
//
//            }
//            return nil
//        }
        
        for i in 0..<shedule.count{
            for j in i..<shedule.count{
                if shedule[i].sectionName == shedule[j].sectionName{
                    shedule[i].sectionObject += shedule[j].sectionObject
                    shedule.remove(at: j)
                }
            }
        }
        
        
        return shedule
    }
}
