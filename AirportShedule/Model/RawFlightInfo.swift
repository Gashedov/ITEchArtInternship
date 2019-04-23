//
//  CommonFlightInfo.swift
//  AirportShedule
//
//  Created by student on 4/8/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct RawFlightInfo {
    var arrivalAirportCode: String?
    var departureAirportCode: String?
    var arrivalTime: Int?
    var departureTime: Int?
}

extension RawFlightInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case arrivalAirportCode = "estArrivalAirport"
        case departureAirportCode = "estDepartureAirport" // code "FFDD"
        case arrivalTime = "lastSeen"
        case departureTime = "firstSeen"
    }
}
