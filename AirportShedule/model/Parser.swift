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

struct PreparedAirportsList {
    let countries: [String]
    let aiportsByCountry: [String : [AirportInfo]]
}

class Parser{
    func prepareDataForDisplay(objects: [AirportInfo]) -> [SheduleInfoToDisplay]{
        
        var aiportsByContry = [String : [AirportInfo]]()
        
        for airport in objects {
            var airports = aiportsByContry[airport.country] ?? []
            airports.append(airport)
            aiportsByContry[airport.country] = airports
        }
        
        let countries = aiportsByContry.keys.sorted()
        let list = PreparedAirportsList(countries: countries, aiportsByCountry: aiportsByContry)
        
        var shedule =  [SheduleInfoToDisplay]()
        
        for country in list.countries{
                shedule.append(SheduleInfoToDisplay(isOpen: false, sectionName: country,
                                                    sectionObject:convertToAttributs(airportInfo: list.aiportsByCountry[country] ?? []) ))
        }
        
        return shedule
    }
    
    private func convertToAttributs(airportInfo : [AirportInfo])-> [Attributs]{
        var attributs = [Attributs]()
        
        for airport in airportInfo{
            attributs.append(Attributs(city: airport.city, airportName: airport.name, code: airport.code ))
        }
        return attributs
    }
}

//        shedule.reduce([SheduleInfoToDisplay]()) { (prev, new) in
//            for i in 0..<prev.count{
//                if prev[i].sectionName == new.sectionName{
//                    SheduleInfoToDisplay(isOpen: false,  sectionName: prev[i].sectionName, sectionObject: prev[i].sectionObject + new.sectionObject)
//                }
//            }
//            return prev
//        }
//
//        var sheduleForDisplay = [SheduleInfoToDisplay]()
//        var attributs = [Attributs]()
//
//        let size  = shedule.count
//        for i in 0..<size{
//            attributs += shedule[i].sectionObject
//            for j in i+1..<size{
//                if shedule[i].sectionName == shedule[j].sectionName{
//                    attributs += shedule[j].sectionObject
//                }
//                }
//            sheduleForDisplay.append(SheduleInfoToDisplay(isOpen: false,  sectionName: shedule[i].sectionName, sectionObject: attributs))
//            attributs = []
//            }
//
//        return sheduleForDisplay
