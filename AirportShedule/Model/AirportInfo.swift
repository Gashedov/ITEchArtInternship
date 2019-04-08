//
//  File.swift
//  AirportTimetable
//
//  Created by student on 3/26/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct AirportInfo {
    var country: String
    var name: String?
    var city: String?
    var code: String
}

extension AirportInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case country
        case name
        case city
        case code = "icao"
    }
}
