//
//  SheduleInfoToDisplay.swift
//  AirportShedule
//
//  Created by student on 4/16/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct SheduleInfoToDisplay {
    var isOpen: Bool
    var airportCountry: String
    var airportAttributs: [Attributs]
}

struct Attributs {
    var city: String?
    var airportName: String?
    var code: String
}
