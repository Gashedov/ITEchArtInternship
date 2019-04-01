//
//  File.swift
//  AirportTimetable
//
//  Created by student on 3/26/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct CommonFlightInfo: Decodable {
    var arrivalAirportName: String?
    var departureAirportName : String?
    var arrivalTime : Int?
    var departureTime: Int?
    
    
    enum CodingKeys : String, CodingKey {
        case arrivalAirportName = "estArrivalAirport"
        case departureAirportName = "estDepartureAirport"
        case arrivalTime = "lastSeen"
        case departureTime = "firstSeen"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(arrivalAirportName, forKey: .arrivalAirportName)
        try container.encode(departureAirportName, forKey: .departureAirportName)
        try container.encode(arrivalTime, forKey: .arrivalTime)
        try container.encode(departureTime, forKey: .departureTime)
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
        arrivalAirportName = try container.decode(String.self, forKey: .arrivalAirportName)
        departureAirportName = try container.decode(String.self, forKey: .departureAirportName)
        arrivalTime = try container.decode(Int.self, forKey: .arrivalTime)
        departureTime = try container.decode(Int.self, forKey: .departureTime)
    }
}

struct AirportInfo{
    var country: String
    var name: String?
    var city: String?
    var code: String
}
extension AirportInfo : Decodable{
    
    enum CodingKeys : String, CodingKey {
        case country
        case name
        case city
        case code = "icao"
    }
    
    
}



