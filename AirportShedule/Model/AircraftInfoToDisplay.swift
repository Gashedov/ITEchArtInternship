//
//  Aircraft.swift
//  AirportShedule
//
//  Created by student on 5/6/19.
//  Copyright © 2019 TyomaProduction. All rights reserved.
//

import Foundation

struct Aircraft {
    let productionLine: String?
    let planeModel: String?
    let modelCode : String?
    let registrationDate: String?
    let planeAge: String?
    let planeOwner: String?
}

extension Aircraft: Decodable {
    enum CodingKeys: String, CodingKey {
        case productionLine
        case planeModel
        case modelCode
        case registrationDate
        case planeAge
        case planeOwner
    }
}
